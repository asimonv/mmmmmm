//
//  View+Layout.swift
//  ColorPicker
//
//  Created by Andre Simon on 13-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

extension View {
    func inExpandingRectangle() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            self
        }
    }
}
