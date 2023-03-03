import UIKit

protocol MainViewProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func showAlert(title: String, message: String)
}

final class MainViewController: UIViewController {

    var presenter: MainPresenterProtocol?

    private let pointsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Сколько точек?"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .gray
        return textField
    }()

    private let goButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Поехали", for: .normal)
        button.setTitleColor(.yellow, for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private lazy var bottomButtonConstraint: NSLayoutConstraint = goButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearence()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {

    func startLoading() {
        goButton.isEnabled = false
        pointsTextField.isEnabled = false
        spinner.startAnimating()
    }

    func stopLoading() {
        goButton.isEnabled = true
        pointsTextField.isEnabled = true
        spinner.stopAnimating()
    }

    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default)
        alertView.addAction(alertAction)
        present(alertView, animated: true)
    }
}

// MARK: - Private Methods

private extension MainViewController {

    func configureAppearence() {
        view.backgroundColor = .systemBackground

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        addingSubviews()
        makeConstraints()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func addingSubviews() {
        view.addSubviews(pointsTextField, goButton, spinner)
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            pointsTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            pointsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            pointsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            pointsTextField.heightAnchor.constraint(equalToConstant: 44.0),

            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
            goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0),
            bottomButtonConstraint,
            goButton.heightAnchor.constraint(equalToConstant: 44.0),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50.0),
            spinner.widthAnchor.constraint(equalTo: spinner.heightAnchor)
        ])
    }

    @objc func goButtonPressed() {
        defer { pointsTextField.resignFirstResponder() }
        guard
            let text = pointsTextField.text,
            let count = Int(text)
        else {
            showAlert(title: "Ошибка", message: "Введите число")
            return
        }
        presenter?.tapButton(count: count)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomButtonConstraint.constant = -16
        view.layoutIfNeeded()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification : Notification?) -> Void {
        
        var _kbSize: CGSize
        
        if let info = notification?.userInfo {
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                bottomButtonConstraint.constant = -16 - _kbSize.height
                view.layoutIfNeeded()
            }
        }
    }
}
