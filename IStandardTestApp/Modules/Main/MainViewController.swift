import UIKit

protocol MainViewProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func showAlert(title: String, message: String)
}

final class MainViewController: UIViewController {

    struct Constants {
        static let pointsTextFieldDefault: CGFloat = 50.0
        static let pointsTextFieldHeight: CGFloat = 56.0

        static let goButtonDefaultIndent: CGFloat = 50.0
        static let goButtonHeight: CGFloat = 56.0
        static let goButtonBottom: CGFloat = 16.0

        static let spinnerHeight: CGFloat = 50.0
    }

    var presenter: MainPresenterProtocol?

    private let pointsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Сколько точек?"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRectMake(0, 0, 10, 20))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1).cgColor
        textField.layer.borderWidth = 2
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 10
        textField.layer.shadowOpacity = 0.2
        textField.tintColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1)
        textField.textColor = UIColor(red: 44 / 255, green: 56 / 255, blue: 68 / 255, alpha: 1)
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return textField
    }()

    private let goButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitle("ПОЕХАЛИ", for: .normal)
        button.setTitleColor(UIColor(red: 44 / 255, green: 56 / 255, blue: 68 / 255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 20
        button.layer.shadowOpacity = 0.5
        return button
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        return spinner
    }()

    private lazy var bottomButtonConstraint: NSLayoutConstraint = goButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                                                   constant: Constants.goButtonBottom.negative)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearence()
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
        view.backgroundColor = .systemCyan

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
            pointsTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Constants.pointsTextFieldDefault),
            pointsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: Constants.pointsTextFieldDefault),
            pointsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: Constants.pointsTextFieldDefault.negative),
            pointsTextField.heightAnchor.constraint(equalToConstant: Constants.pointsTextFieldHeight),

            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                              constant: Constants.goButtonDefaultIndent),
            goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: Constants.goButtonDefaultIndent.negative),
            bottomButtonConstraint,
            goButton.heightAnchor.constraint(equalToConstant: Constants.goButtonHeight),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: Constants.spinnerHeight),
            spinner.widthAnchor.constraint(equalTo: spinner.heightAnchor)
        ])
    }

    @objc func goButtonPressed() {
        presenter?.tapButton(count: pointsTextField.text)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomButtonConstraint.constant = Constants.goButtonBottom.negative
        view.layoutIfNeeded()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification : Notification?) {
        if let kbFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let screenSize = UIScreen.main.bounds
            let intersectRect = kbFrame.intersection(screenSize)

            let kbSize = intersectRect.isNull ? CGSize(width: screenSize.size.width, height: 0) : intersectRect.size
            bottomButtonConstraint.constant = Constants.goButtonBottom.negative - kbSize.height
            view.layoutIfNeeded()
        }
    }
}
