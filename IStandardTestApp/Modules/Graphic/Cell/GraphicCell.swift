import UIKit

final class GraphicCell: UITableViewCell {

    func set(model: Point) {
        var cellConfig = defaultContentConfiguration()
        cellConfig.text = "x: \(model.x) y: \(model.y)"
        contentConfiguration = cellConfig
    }
}
