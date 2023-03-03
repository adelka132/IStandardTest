import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        view.forEach(addSubview(_:))
    }
}
