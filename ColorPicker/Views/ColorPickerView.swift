//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Andre Simon on 12-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var chosenColor: UIColor
    @Binding var isDragging: Bool

    @State private var startLocation: CGPoint = .zero
    @State private var lastLocation: CGPoint = .zero
    @State private var dragOffset: CGSize = .zero
    @State var saturationMode: Bool = false

    init(chosenColor: Binding<UIColor>, isDragging: Binding<Bool>) {
        self._chosenColor = chosenColor
        self._isDragging = isDragging
    }
    
    private var colors: [Color] = {
        let hueValues = Array(0...359)
        return hueValues.map {
            Color(UIColor(hue: CGFloat($0) / 359.0 ,
                          saturation: 1.0,
                          brightness: 1.0,
                          alpha: 1.0))
        }
    }()
    
    // 2
    private var circleWidth: CGFloat {
        isDragging ? 35 : 15
    }
    
    private var linearGradientHeight: CGFloat = 200
    private var threshold: CGFloat = 20
    
    /// Get the current color based on our current translation within the view
    private var currentColor: Color {
        Color(UIColor.init(hue: self.normalizeGesture().y / self.linearGradientHeight, saturation: self.saturationMode ? 1.0 - self.normalizeGesture(saturation: true).y / self.linearGradientHeight : 1.0, brightness: 1.0 - abs(self.normalizeGesture().x) / 320, alpha: 1.0))
    }
    
    /// Normalize our gesture to be between 0 and 200, where 200 is the height.
    /// At 0, the users finger is on top and at 200 the users finger is at the bottom
    private func normalizeGesture(saturation: Bool = false) -> (x: CGFloat, y: CGFloat) {
        let offsetY = (self.saturationMode ? lastLocation.y : startLocation.y) + dragOffset.height // Using our starting point, see how far we've dragged +- from there
        let maxY = max(0, offsetY) // We want to always be greater than 0, even if their finger goes outside our view
        let minY = min(maxY, linearGradientHeight) // We want to always max at 200 even if the finger is outside the view.
        
        let offsetX = startLocation.x + dragOffset.width
        let maxX = max(-320, offsetX)
        let minX = min(maxX, 0)
        
        return (minX, self.saturationMode ? (saturation ? minY : self.lastLocation.y) : minY)
    }
    
    // todo: update last start location when user moves > -10 to the right
    func getNewLocation(translation: DragGesture.Value) -> CGPoint {
        if translation.translation.width < -threshold && !self.saturationMode{
            self.saturationMode = true
            self.lastLocation = CGPoint(x: startLocation.x, y: startLocation.y + translation.translation.height)
        } else if saturationMode {
            if translation.translation.width >= -threshold {
                self.saturationMode = false
                    self.lastLocation = CGPoint(x: startLocation.x, y: startLocation.y + translation.translation.height)
                
            } else {
                print("last location: \(self.lastLocation)")
            }
        }
        return translation.startLocation
    }
    
    var body: some View {
        // 3
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: colors),
                           startPoint: .top,
                           endPoint: .bottom)
                .frame(width: 10, height: linearGradientHeight)
                .cornerRadius(5)
                .shadow(radius: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 5).stroke(Color.white.opacity(0.8), lineWidth: 2.0)
                )
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            self.dragOffset = value.translation
                            self.startLocation = self.getNewLocation(translation: value)
                            self.chosenColor = UIColor.init(hue: self.normalizeGesture().y / self.linearGradientHeight, saturation: self.saturationMode ? 1.0 - self.normalizeGesture(saturation: true).y / self.linearGradientHeight : 1.0, brightness: 1.0 - abs(self.normalizeGesture().x) / 320, alpha: 1.0)
                            self.isDragging = true // 4
                        })
                        // 5
                        .onEnded({ (_) in
                            self.isDragging = false
                        })
            )
            
            // 6
            Circle()
                .foregroundColor(self.currentColor)
                .frame(width: self.circleWidth, height: self.circleWidth, alignment: .center)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: self.circleWidth / 2.0).stroke(Color.white, lineWidth: 2.0)
                )
                .offset(x: self.isDragging ? self.circleWidth : 0.0, y: self.normalizeGesture().y - self.circleWidth / 2)
                .animation(Animation.spring().speed(2))
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(chosenColor: Binding.constant(UIColor.red), isDragging: Binding.constant(false))
    }
}
