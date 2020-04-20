//
//  RadialGradientView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct RadialGradientView: View {
    @Binding var pickedColors: [UIColor]
    @Binding var scale: CGFloat

    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(gradient: Gradient(colors: pickedColors.map({ color in
                    Color(color)
                })), center: .center, startRadius: 1, endRadius: 100)
        ).scaleEffect(scale)
        .gesture(MagnificationGesture().onChanged {
            self.scale = max($0.magnitude, 1.0)
        })
    }
}

struct RadialGradientView_Previews: PreviewProvider {
    static var previews: some View {
        RadialGradientView(pickedColors: Binding.constant([]), scale: Binding.constant(1.0))
    }
}
