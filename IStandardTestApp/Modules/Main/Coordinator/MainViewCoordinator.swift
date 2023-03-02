import UIKit

protocol MainViewCoordinatorProtocol: AnyObject {
    func showGraphic(with points: [Point])
}

final class MainViewCoordinator: Coordinator {

    var coordinators: [Coordinator] = []

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MainViewController()
        let service = PointService()
        let presenter = MainPresenter(view: viewController,
                                      networkService: service) { [weak self] rout in
            switch rout {
            case .showGraphic(let points):
                self?.showGraphic(with: points)
            }
        }
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainViewCoordinator: MainViewCoordinatorProtocol {
    func showGraphic(with points: [Point]) {
        let viewController = GraphicViewController()
        let presenter = GraphicPresenter(view: viewController, points: points)
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
