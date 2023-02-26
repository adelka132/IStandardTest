import UIKit

protocol MainViewProtocol: AnyObject {
    func configureAppearence()
}

final class MainViewController: UIViewController {

    var presenter: MainPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension MainViewController: MainViewProtocol {

    func configureAppearence() {
        view.backgroundColor = .orange
    }
}
