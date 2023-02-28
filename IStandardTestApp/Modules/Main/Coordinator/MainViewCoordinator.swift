import UIKit

protocol MainViewCoordinatorProtocol: AnyObject {
    func showGraphic(with data: GraphicData)
}

final class MainViewCoordinator: Coordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MainViewController()
        let service = PointService()
        let presenter = MainPresenter(view: viewController, networkService: service, coordinator: self)
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainViewCoordinator: MainViewCoordinatorProtocol {
    func showGraphic(with data: GraphicData) {
        let coordinator = GraphicViewCoordinator(navigationController: navigationController, graphicData: data)
//        coordinator.start()
        coordinate(to: coordinator)
    }
}
