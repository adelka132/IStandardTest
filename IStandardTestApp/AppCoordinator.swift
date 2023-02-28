import UIKit

final class AppCoordinator: Coordinator {

    private weak var window: UIWindow?
    private var rootViewController: UINavigationController?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        rootViewController = UINavigationController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    func showMainViewController() {
        let mainVC = MainViewCoordinator(navigationController: rootViewController!)
        coordinate(to: mainVC)
    }
}
