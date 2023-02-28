import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        appCoordinator?.showMainViewController()
        return true
    }
}
