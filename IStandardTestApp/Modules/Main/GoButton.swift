import UIKit

final class GoButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        confogureAppearence()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func confogureAppearence() {
        backgroundColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1)
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5

        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        setTitle("ПОЕХАЛИ", for: .normal)
        let titleColor = UIColor(red: 44 / 255, green: 56 / 255, blue: 68 / 255, alpha: 1)
        setTitleColor(titleColor, for: .normal)
    }
}
