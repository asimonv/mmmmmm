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
    
    private let maxX = UIScreen.main.bounds.maxX
    private let maxY = UIScreen.main.bounds.maxY
    
    var body: some View {
        switch(gradientType) {
        case 0:
            return AnyView(Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: pickedColors.map({ color in
                    Color(color)
                })), startPoint: .top, endPoint: .bottom)
            ))
        case 1:
            return AnyView(Rectangle()
            .fill(
                AngularGradient(gradient: Gradient(colors: pickedColors.map({ color in
                    Color(color)
                })), center: centerPosition, angle: rotationValue)
            )
                .gesture(RotationGesture().onChanged({ value in
                    self.rotationValue = value;
                })).simultaneousGesture(DragGesture().onChanged({ value in
                    print("x: \(value.location.x), y: \(value.location.y)")
                    self.centerPosition = UnitPoint(x: value.location.x / self.maxX , y: value.location.y / self.maxY)
                })))
        case 2:
            return AnyView(Rectangle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: pickedColors.map({ color in
                        Color(color)
                    })), center: .center, startRadius: 1, endRadius: 100)
            ))
        default:
            return AnyView(Rectangle())
        }
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView(gradientType: Binding.constant(0), pickedColors: Binding.constant([UIColor.red]), rotationValue: Binding.constant(.zero), centerPosition: Binding.constant(.center))
    }
}
