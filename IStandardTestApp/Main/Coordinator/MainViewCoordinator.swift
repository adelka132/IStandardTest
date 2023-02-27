import UIKit

final class MainViewCoordinator: Coordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MainViewController()
        let service = PointService()
        let presenter = MainPresenter(view: viewController, networkService: service)
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
