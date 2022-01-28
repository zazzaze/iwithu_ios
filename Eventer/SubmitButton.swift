//
//  SubmiButton.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

final class SubmitButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setTitleColor(Colors.titleColor, for: .normal)
        backgroundColor = Colors.accentColor
        layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = Colors.accentColor
            } else {
                self.backgroundColor = .clear
            }
        }
    }
}
