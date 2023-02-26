import UIKit

final class AppCoordinator: Coordinator {

    private weak var window: UIWindow?
    private var rootViewController: UINavigationController?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        rootViewController = makeRootViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    private func makeRootViewController() -> UINavigationController {
        let viewController = MainViewController()
        let presenter = MainPresenter(view: viewController)
        viewController.presenter = presenter
        return UINavigationController(rootViewController: viewController)
    }
}
