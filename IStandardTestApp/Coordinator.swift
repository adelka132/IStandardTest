import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    var coordinators: [Coordinator] { get set }

    func start()
}

// Опционально, сказать что у нас 0999999 координаторов и мб понадобиться
extension Coordinator {
    func removeChildCoordinator(_ coordinator: Coordinator) {
        guard let index = coordinators.firstIndex(where: { $0 === coordinator }) else { return }
        coordinators.remove(at: index)
    }
}
