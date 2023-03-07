import UIKit

final class GraphicCell: UITableViewCell {

    private let customSelectedColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Palete.customYellow
        return view
    }()

    // MARK: - UITableViewCell

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearence()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(model: Point) {
        var cellConfig = defaultContentConfiguration()
        cellConfig.text = "x: \(model.x) y: \(model.y)"
        cellConfig.textProperties.alignment = .center
        cellConfig.textProperties.color = UIColor.Palete.customDarkGray
        cellConfig.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        contentConfiguration = cellConfig
    }

    private func configureAppearence() {
        backgroundColor = .systemCyan
        selectedBackgroundView = customSelectedColor
    }
}
