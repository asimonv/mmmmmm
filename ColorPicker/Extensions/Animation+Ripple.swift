//
//  Animation+Ripple.swift
//  ColorPicker
//
//  Created by Andre Simon on 13-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

extension Animation {
    static func ripple(delay: Double = 0.0) -> Animation {
        Animation.spring(dampingFraction: 0.5).delay(delay)
    }
}
