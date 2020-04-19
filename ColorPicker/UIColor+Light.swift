//
//  UIColor+Light.swift
//  ColorPicker
//
//  Created by Andre Simon on 13-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import UIKit

extension UIColor
{
    func isLight() -> Bool
    {
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        let components: [CGFloat] = self.cgColor.components!
        let sum: CGFloat = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114))
        let brightness: CGFloat = sum / 1000
        return brightness < 0.5

    }
}
