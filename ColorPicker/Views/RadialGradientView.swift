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
    @State var currPosition: Int = 0
    @State var centerPosition: UnitPoint = .center

    private let radiusPositions: [UnitPoint] = [.center, .leading, .bottomLeading, .bottom, .bottomTrailing, .trailing, .topTrailing, .top, .topLeading]
    private let maxX = UIScreen.main.bounds.maxX
    private let maxY = UIScreen.main.bounds.maxY
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: self.pickedColors.map({ color in
                        Color(color)
                    })), center: self.centerPosition, startRadius: 1, endRadius: 150*self.scale)
            )
            .gesture(MagnificationGesture().onChanged {
                self.scale = max($0.magnitude, 1.0)
            }).simultaneousGesture(DragGesture().onChanged({ value in
                self.centerPosition = UnitPoint(x: value.location.x / self.maxX , y: value.location.y / self.maxY)
            }))
        }
    }
}

struct RadialGradientView_Previews: PreviewProvider {
    static var previews: some View {
        RadialGradientView(pickedColors: Binding.constant([]), scale: Binding.constant(1.0))
    }
}
