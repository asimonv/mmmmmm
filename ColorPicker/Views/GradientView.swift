//
//  GradientView.swift
//  ColorPicker
//
//  Created by Andre Simon on 19-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct GradientView: View {
    @Binding var gradientType: Int
    @Binding var pickedColors: [UIColor]
    @Binding var rotationValue: Angle
    @Binding var centerPosition: UnitPoint
    @Binding var radialScale: CGFloat
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        switch(gradientType) {
        case 0:
            return AnyView(Color(pickedColors.count > 0 ? UIColor.blend(colors: pickedColors) : .white))
        case 1:
            return AnyView(LinearGradientView(pickedColors: $pickedColors))
        case 2:
            return AnyView(AngularGradientView(pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition))
        case 3:
            return AnyView(RadialGradientView(pickedColors: $pickedColors, scale: $radialScale))
        case 4:
            return AnyView(ImageBlurredView(selectedImage: $selectedImage))
        default:
            return AnyView(Rectangle())
        }
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView(gradientType: Binding.constant(0), pickedColors: Binding.constant([UIColor.red]), rotationValue: Binding.constant(.zero), centerPosition: Binding.constant(.center), radialScale: Binding.constant(1.0), selectedImage: Binding.constant(nil))
    }
}
