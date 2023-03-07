import UIKit

final class GoButton: UIButton {

    private enum Constants {
        static let backgroundColor = UIColor.Palete.customYellow
        static let shadowColor = UIColor.black.cgColor
        static let titleColor = UIColor.Palete.customDarkGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearence()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearence() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = 10
        layer.shadowColor = Constants.shadowColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5

        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        setTitle("ПОЕХАЛИ", for: .normal)
        setTitleColor(Constants.titleColor, for: .normal)
    }
}
