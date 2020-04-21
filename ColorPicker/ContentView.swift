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
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    @State var centerPosition: UnitPoint = .center
    @State var rotationValue: Angle = .zero
    @State var radialScale: CGFloat = 1.0
    
    @State var notificationText: String = "Background saved."
    
    @State var pickedColors: [UIColor] = []
    
    func shuffleAction() -> Void {
        self.gradientType = (self.gradientType + 1) % 4
    }
    
    func addColor() -> Void {
        pickedColors.insert(currentColor, at: 0)
    }
    
    func clearAction() -> Void {
        self.pickedColors = []
        self.gradientType = 0
    }
    
    /*
        0: Single
        1: Linear
        2: Angular
        3: Radial
     */
    func saveBackground() -> Void {
        var image: UIImage!
        switch gradientType {
        case 0:
            image = UIImage(color: UIColor.blend(colors: pickedColors), size: UIScreen.main.bounds.size)!
        case 1:
            image = LinearGradientView(pickedColors: $pickedColors).asImage()
        case 2:
            image = AngularGradientView(pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition).asImage()
        case 3:
            image = RadialGradientView(pickedColors: $pickedColors, scale: $radialScale).asImage()
        default:
            image = UIImage(color: currentColor, size: UIScreen.main.bounds.size)!
        }
                
        CustomPhotoAlbum.shared.save(image, completion: { result, error in
            if error != nil {
                // handle error
                self.showAlert = true
                self.alertMessage = error!.localizedDescription
                return
            }
            // save successful, do something (such as inform user)
            self.backgroundSaved = !self.backgroundSaved
        })
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
                        if pickedColors.count > 0 {
                            ColorsView(pickedColors: $pickedColors)
                        }
                        ActionsView(pickedColors: $pickedColors, shuffleAction: shuffleAction, addColor: addColor, saveBackground: saveBackground, clearAction: clearAction)
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), primaryButton: .cancel(Text("Cancel")), secondaryButton: Alert.Button.default(Text("Settings")) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
