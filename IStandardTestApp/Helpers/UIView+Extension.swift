import UIKit

extension UIView {
    func addSubview(_ view: UIView...) {
        view.forEach(addSubview(_:))
    }
}
