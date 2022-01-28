//
//  Colors.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

enum Colors {
    static let backgroundColor = UIColor(red: 36.0/255, green: 46.0/255, blue: 51.0/255, alpha: 1.0)
    static let subtitleTextColor = UIColor(hex: 0xAFB9BD, alpha: 1.0)
    static let foregroundColor = UIColor(hex: 0x30393E, alpha: 1.0)
    static let titleColor = UIColor.white
    static let accentColor = UIColor(hex: 0x47C9FF, alpha: 1.0)
    static let dividerColor = UIColor(hex: 0x59656A, alpha: 1.0)
}

extension UIColor {
    convenience init(
        red: Int,
        green: Int,
        blue: Int,
        alpha: CGFloat
    ) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
   }

    convenience init(hex: Int, alpha: CGFloat) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF,
           alpha: alpha
       )
   }
}
