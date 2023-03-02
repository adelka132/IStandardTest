import UIKit

final class GraphicCell: UITableViewCell {

    private var model: Point? {
        didSet { makeConfiguration() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(model: Point) {
        self.model = model
    }
}

private extension GraphicCell {
    func makeConfiguration() {
        var cellConfig = defaultContentConfiguration()
        let xPoint = String(optionallyDescribing: model?.x)
        let yPoint = String(optionallyDescribing: model?.y)
        cellConfig.text = "x: \(xPoint) y: \(yPoint)"
        contentConfiguration = cellConfig
    }
}

extension UITableViewCell {
    static var identifier: String { String(describing: self) }
}
