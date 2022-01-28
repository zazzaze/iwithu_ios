import Foundation
import UIKit

class Switcher: UIView {

    static let activeColor = Colors.titleColor
    static let disabledColor = Colors.subtitleTextColor

    weak var delegate: SwitcherDelegate?

    let firstLabel = UILabel()
    let secondLabel = UILabel()

    private var selection: SwitcherSelection = .first

    override init(frame: CGRect) {
        super.init(frame: frame)

        firstLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        secondLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        firstLabel.textColor = Self.activeColor
        secondLabel.textColor = Self.disabledColor

        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center

        [firstLabel, secondLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }

        let firstGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapFirst(_:)))
        let secondGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSecond(_:)))

        firstLabel.addGestureRecognizer(firstGesture)
        firstLabel.isUserInteractionEnabled = true
        secondLabel.addGestureRecognizer(secondGesture)
        secondLabel.isUserInteractionEnabled = true

        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstLabel.topAnchor.constraint(equalTo: topAnchor),
            firstLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            firstLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6.5),

            secondLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 6.5),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondLabel.topAnchor.constraint(equalTo: topAnchor),
            secondLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc func didTapFirst(_ sender: UITapGestureRecognizer?) {
        guard selection == .second else { return }
        selection = .first
        delegate?.switcher(self, didChangeActive: .first)
        firstLabel.textColor = Self.activeColor
        secondLabel.textColor = Self.disabledColor
    }

    @objc func didTapSecond(_ sender: UITapGestureRecognizer?) {
        guard selection == .first else { return }
        selection = .second
        delegate?.switcher(self, didChangeActive: .second)
        firstLabel.textColor = Self.disabledColor
        secondLabel.textColor = Self.activeColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SwitcherDelegate: AnyObject {
    func switcher(_ switcher: Switcher, didChangeActive: SwitcherSelection)
}

enum SwitcherSelection {
    case first
    case second
}
