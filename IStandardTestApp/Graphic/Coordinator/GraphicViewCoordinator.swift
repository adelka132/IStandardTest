import UIKit

final class GraphicViewCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let graphicData: GraphicData

    init(navigationController: UINavigationController, graphicData: GraphicData) {
        self.navigationController = navigationController
        self.graphicData = graphicData
    }

    func start() {
        let viewController = GraphicViewController()
        let presenter = GraphicPresenter(view: viewController, graphicData: graphicData)
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}
