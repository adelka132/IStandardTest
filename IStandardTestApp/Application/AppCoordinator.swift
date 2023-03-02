import UIKit

final class AppCoordinator: Coordinator {

    var coordinators: [Coordinator] = []

    private weak var window: UIWindow?
    var navigationController: UINavigationController = UINavigationController()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        showMainViewController()
    }

    func showMainViewController() {
        let mainCoordinator = MainViewCoordinator(navigationController: navigationController)
        coordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
