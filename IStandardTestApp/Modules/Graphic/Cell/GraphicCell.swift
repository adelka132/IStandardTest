import UIKit

final class GraphicCell: UITableViewCell {

    private let customSelectedColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1)
        return view
    }()

    func set(model: Point) {
        var cellConfig = defaultContentConfiguration()
        cellConfig.text = "x: \(model.x) y: \(model.y)"
        cellConfig.textProperties.alignment = .center
        cellConfig.textProperties.color = UIColor(red: 44 / 255, green: 56 / 255, blue: 68 / 255, alpha: 1)
        cellConfig.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        contentConfiguration = cellConfig
    }

    func configureAppearence() {
        backgroundColor = .systemCyan
        selectedBackgroundView = customSelectedColor
    }
}
