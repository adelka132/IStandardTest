import UIKit

protocol MainViewCoordinatorProtocol: AnyObject {
    func showGraphic(with data: GraphicData)
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
            case .showGraphic(let data):
                self?.showGraphic(with: data)
            }
        }
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainViewCoordinator: MainViewCoordinatorProtocol {
    func showGraphic(with data: GraphicData) {
        let viewController = GraphicViewController()
        let presenter = GraphicPresenter(view: viewController, graphicData: data)
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
