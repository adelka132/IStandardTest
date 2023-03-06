import UIKit

final class PointsTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearence()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }

    private func configureAppearence() {
        placeholder = "Сколько точек?"
        keyboardType = .numberPad
        backgroundColor = .white
        leftView = UIView(frame: CGRectMake(0, 0, 10, 20))
        leftViewMode = .always
        layer.cornerRadius = 10
        layer.borderColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1).cgColor
        layer.borderWidth = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        tintColor = UIColor(red: 248 / 255, green: 216 / 255, blue: 28 / 255, alpha: 1)
        textColor = UIColor(red: 44 / 255, green: 56 / 255, blue: 68 / 255, alpha: 1)
        font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
}
