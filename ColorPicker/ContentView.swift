	//
//  ContentView.swift
//  ColorPicker
//
//  Created by Andre Simon on 12-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var currentColor: UIColor = .red
    @State var isDragging: Bool = false
    @State var backgroundSaved: Bool = false
    
    @State var gradientType = 0
    
    @State var centerPosition: UnitPoint = .center
    @State var rotationValue: Angle = .zero
    
    @State var pickedColors: [UIColor] = [
        .purple, .red, .cyan
    ]
    
    func shuffleAction() -> Void {
        self.gradientType = (self.gradientType + 1) % 3
    }
    
    func addColor() -> Void {
        pickedColors.insert(currentColor, at: 0)
    }
    
    
    func saveBackground() -> Void {
        var image: UIImage!
        if gradientType == 0 {
            image = Rectangle()
            .fill(
                AngularGradient(gradient: Gradient(colors: pickedColors.map({ color in
                    Color(color)
                })), center: centerPosition, angle: self.rotationValue)
                ).asImage().dithered(intensity: 3)
        } else {
            image = UIImage(color: currentColor, size: UIScreen.main.bounds.size)!
        }
                
        CustomPhotoAlbum.sharedInstance.save(image, completion: { result, error in
            if error != nil {
                // handle error
                print(error!)
                return
            }
            // save successful, do something (such as inform user)
            self.backgroundSaved = !self.backgroundSaved
        })
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GradientView(gradientType: $gradientType, pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition)
            // background hack to make ColorPickerView have gesture preference over GradientView
            ColorPickerView(chosenColor: $currentColor, isDragging: $isDragging)
                .frame(width: 50, height: 200).padding([.top], 80).background(Color.white.opacity(0.0001))
            
            VStack(alignment: .leading) {
                if backgroundSaved {
                    SavedView(currentColor: $currentColor, callback: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.backgroundSaved = false
                            }
                        }
                    })
                }
                if !isDragging {
                    VStack(alignment: .trailing) {
                        Spacer().frame(maxWidth: .infinity)
                        ColorsView(pickedColors: $pickedColors)
                        ActionsView(shuffleAction: shuffleAction, addColor: addColor, saveBackground: saveBackground)
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.ripple())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
