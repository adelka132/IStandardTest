import UIKit

protocol MainViewProtocol: AnyObject {
    func configureAppearence()
}

final class MainViewController: UIViewController {

    var presenter: MainPresenterProtocol?

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Сколько точек?"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension MainViewController: MainViewProtocol {

    func configureAppearence() {
        view.backgroundColor = .white
        goButton.addTarget(self, action: #selector(getText), for: .touchUpInside)
        addSubviews()
        makeConstraints()
    }
}

private extension MainViewController {

    func addSubviews() {
        view.addSubview(textField)
        view.addSubview(goButton)
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            textField.heightAnchor.constraint(equalToConstant: 44.0),

            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
            goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0),
            goButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }

    @objc func getText() {
        presenter?.tapButton()
    }
}

extension Data {
    var prettyJson: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data,
                                                 encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
