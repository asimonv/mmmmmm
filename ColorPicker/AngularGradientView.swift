//
//  AngularGradientView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct AngularGradientView: View {
    @Binding var pickedColors: [UIColor]
    @Binding var rotationValue: Angle
    @Binding var centerPosition: UnitPoint
    
    private let maxX = UIScreen.main.bounds.maxX
    private let maxY = UIScreen.main.bounds.maxY
    
    var body: some View {
        Rectangle()
        .fill(
            AngularGradient(gradient: Gradient(colors: pickedColors.map({ color in
                Color(color)
            })), center: centerPosition, angle: rotationValue)
        )
            .gesture(RotationGesture().onChanged({ value in
                self.rotationValue = value;
            })).simultaneousGesture(DragGesture().onChanged({ value in
                self.centerPosition = UnitPoint(x: value.location.x / self.maxX , y: value.location.y / self.maxY)
            }))
    }
}

struct AngularGradientView_Previews: PreviewProvider {
    static var previews: some View {
        AngularGradientView(pickedColors: Binding.constant([]), rotationValue: Binding.constant(.zero), centerPosition: Binding.constant(.center))
    }
}
