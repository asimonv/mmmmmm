//
//  LinearGradientView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct LinearGradientView: View {
    @Binding var pickedColors: [UIColor]
    @State var firstPointIndex: Int = 0
    let gradientsPositions: [(UnitPoint, UnitPoint)] = [
        (.top, .bottom),
        (.bottom, .top),
        (.bottomTrailing, .topLeading),
        (.bottomLeading, .topTrailing),
        (.topLeading, .bottomTrailing),
        (.topTrailing, .bottomLeading),
        (.center, .top),
        (.center, .bottom),
        (.center, .bottomLeading),
        (.center, .bottomTrailing),
        (.center, .topLeading),
        (.center, .topTrailing),
        (.top, .center),
        (.bottom, .center),
        (.bottomLeading, .center),
        (.bottomTrailing, .center),
        (.topLeading, .center),
        (.topTrailing, .center)
    ]
    
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: self.pickedColors.map({ color in
                    Color(color)
                })), startPoint: self.gradientsPositions[self.firstPointIndex].0, endPoint: self.gradientsPositions[self.firstPointIndex].1)
            ).gesture(
                // hack to detect tap location
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onEnded { tap in
                        if tap.location.x > geometry.size.width / 2 {
                            self.firstPointIndex = (self.firstPointIndex + 1) % self.gradientsPositions.count
                        } else {
                            self.firstPointIndex = max(0, (self.firstPointIndex - 1)) % self.gradientsPositions.count
                        }
                }
            )
        }
    }
}

struct LinearGradientView_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradientView(pickedColors: Binding.constant([]))
    }
}
