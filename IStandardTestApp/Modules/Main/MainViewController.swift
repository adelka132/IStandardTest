import UIKit

protocol MainViewProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func showAlert(title: String, message: String)
}

final class MainViewController: UIViewController {

    private enum Constants {
        static let pointsTextFieldDefault: CGFloat = 50.0
        static let pointsTextFieldHeight: CGFloat = 56.0

        static let goButtonDefaultIndent: CGFloat = 50.0
        static let goButtonHeight: CGFloat = 56.0
        static let goButtonBottom: CGFloat = 16.0

        static let spinnerHeight: CGFloat = 50.0
    }

    var presenter: MainPresenterProtocol?

    private let pointsTextField: PointsTextField = {
        let textField = PointsTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let goButton: GoButton = {
        let button = GoButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
