import UIKit

protocol MainViewProtocol: AnyObject {
    func startSpinner()
    func stopSpinner()
}

final class MainViewController: UIViewController {

    var presenter: MainPresenterProtocol?

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Сколько точек?"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .gray
        return textField
    }()

    private let goButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Поехали", for: .normal)
        button.backgroundColor = .brown
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
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {

    func startSpinner() {
        spinner.startAnimating()
    }

    func stopSpinner() {
        spinner.stopAnimating()
    }
}

// MARK: - Private Methods

private extension MainViewController {

    func configureAppearence() {
        view.backgroundColor = .systemBackground
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        addSubviews()
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

    func addSubviews() {
        view.addSubview(textField, goButton, spinner)
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            textField.heightAnchor.constraint(equalToConstant: 44.0),

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
        defer { textField.resignFirstResponder() }
        guard
            let text = textField.text,
            let count = Int(text)
        else { return }
        presenter?.tapButton(count: count)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomButtonConstraint.constant = -16
        view.layoutIfNeeded()
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
                bottomButtonConstraint.constant -= _kbSize.height
                view.layoutIfNeeded()
            }
        }
    }
}
