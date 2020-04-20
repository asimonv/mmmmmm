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
    @State var radialScale: CGFloat = 1.0
    
    @State var notificationText: String = "Background saved."
    
    @State var pickedColors: [UIColor] = [
        .purple, .red, .cyan
    ]
    
    func shuffleAction() -> Void {
        self.gradientType = (self.gradientType + 1) % 3
    }
    
    func addColor() -> Void {
        pickedColors.insert(currentColor, at: 0)
    }
    
    /*
        0: Linear
        1: Angular
        2: Radial
     */
    func saveBackground() -> Void {
        var image: UIImage!
        switch gradientType {
        case 0:
            image = LinearGradientView(pickedColors: $pickedColors).asImage()
        case 1:
            image = AngularGradientView(pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition).asImage()
        case 2:
            image = RadialGradientView(pickedColors: $pickedColors, scale: $radialScale).asImage()
        default:
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
        // self.backgroundSaved = !self.backgroundSaved

    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GradientView(gradientType: $gradientType, pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition, radialScale: $radialScale)
            // background hack to make ColorPickerView have gesture preference over GradientView
            ColorPickerView(chosenColor: $currentColor, isDragging: $isDragging)
                .frame(width: 50, height: 200).padding([.top], 80).background(Color.white.opacity(0.0001)).padding([.trailing], 35)
            
            VStack(alignment: .leading) {
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
                if backgroundSaved {
                    SavedView(currentColor: $currentColor, notificationText: $notificationText, callback: {
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                             withAnimation {
                                 self.backgroundSaved = false
                             }
                         }
                     }).padding(.all)
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
