import UIKit

final class MainViewCoordinator: Coordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MainViewController()
        let presenter = MainPresenter(view: viewController)
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
