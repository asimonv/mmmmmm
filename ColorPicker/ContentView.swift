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
    @State var showNotification: Bool = false
    
    @State var gradientType = 0
    
    @State var showAlert: Bool = false
    @State var showingSheet: Bool = false
    @State var alertMessage: String = ""
    
    @State var centerPosition: UnitPoint = .center
    @State var rotationValue: Angle = .zero
    @State var radialScale: CGFloat = 1.0
    @State var showImagePicker: Bool = false

    @State var notificationText = NotificationType.backgroundSaved
    @State var open = false

    @State var pickedColors: [UIColor] = []
    @State var selectedImage: UIImage? = nil
    
    @State var imageOption: Int = 0
    
    @State var errorType: Int = -1
    
    func shuffleAction() -> Void {
        self.gradientType = (self.gradientType + 1) % 4
    }
    
    func addColor() -> Void {
        pickedColors.insert(currentColor, at: 0)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func clearAction() -> Void {
        self.pickedColors = []
        self.gradientType = 0
    }
    
    func pickImageAction() -> Void {
        //self.showImagePicker.toggle()
        self.showingSheet.toggle()
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
                self.errorType = 0
                self.alertMessage = error!.localizedDescription
                // save successful, do something (such as inform user)
            } else {
                self.notificationText = .backgroundSaved
                self.showNotification = !self.showNotification
            }
        })
    }
    
    var body: some View {
        
        let buttonsImage = [
            AnyView(MenuItem(icon: "trash", action: clearAction, color: .pink)),
            AnyView(MenuItem(icon: "photo", action: pickImageAction,  color: .blue)),
            AnyView(MenuItem(icon: "arrow.down.to.line", action: saveBackground, color: Color(hex: "#00b894"))),
            AnyView(MenuItem(icon: "paintbrush.fill", action: addColor, color: .blue)),
            AnyView(MenuItem(icon: "shuffle", action: shuffleAction, color: .blue))
        ]
        
        let mainButton3 = AnyView(MainButton(imageName: "plus.circle.fill", colorHex: "f7b731"))

        let menu3 = FloatingButton(mainButtonView: mainButton3, buttons: buttonsImage)
        .circle()
        .startAngle(.pi)
        .endAngle(2 * .pi)
        .radius(80)
        .delays(delayDelta: 0.1)
        .spacing(10)
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(0.0))
        
        return ZStack {
            GradientView(gradientType: $gradientType, pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition, radialScale: $radialScale, selectedImage: $selectedImage)
            .onLongPressGesture(minimumDuration: 1) {
                let pasteboard = UIPasteboard.general
                if pasteboard.hasImages {
                    let extractedColors = pasteboard.image!.getColors()
                    self.pickedColors.append(contentsOf: [(extractedColors?.detail)!, (extractedColors?.background)!, (extractedColors?.primary)!, (extractedColors?.secondary)!])
                    
                    self.notificationText = .imagePasted
                    self.showNotification = !self.showNotification
                }
                else if let string = pasteboard.string {
                    let regexResult = matches(for: "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", in: string.trimmingCharacters(in: .whitespaces))
                    if regexResult.count > 0 {
                        self.pickedColors.append(Color(hex: regexResult[0]).uiColor())
                        self.notificationText = .colorPasted
                        self.showNotification = !self.showNotification
                    } else {
                        self.showAlert = !self.showAlert
                        self.errorType = 1
                    }
                }
            }
            GeometryReader { geometry in
                VStack {
                    // background hack to make ColorPickerView have gesture preference over GradientView
                    HStack {
                        Spacer()
                        VStack {
                            ColorPickerView(chosenColor: self.$currentColor, isDragging: self.$isDragging)
                            .frame(width: 60, height: 200)
                            .padding([.top], 80)
                            .background(Color.white.opacity(0.0001))
                            .padding([.trailing], 25)
                            
                            if !self.isDragging {
                                VStack(alignment: .trailing) {
                                    if self.pickedColors.count > 0 {
                                        ColorsView(pickedColors: self.$pickedColors)
                                    }
                                }
                                .transition(.move(edge: .trailing))
                                .animation(.ripple())
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 22))
                            }
                        }
                    }
                    Spacer()
                    menu3.frame(width: 200, height: 80, alignment: .bottom)
                    if self.showNotification {
                         SavedView(currentColor: self.$currentColor, notificationText: self.$notificationText, callback: {
                             DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                  withAnimation {
                                      self.showNotification = false
                                  }
                              }
                          }).padding(.all)
                    }
                }
                .frame(width: geometry.size.width, height: nil)
                .padding([.bottom], 40)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            if (errorType == 0) {
                return Alert(title: Text("Oops!"), message: Text(alertMessage), primaryButton: .cancel(Text("Cancel")), secondaryButton: Alert.Button.default(Text("Settings")) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
            }
            return Alert(title: Text("Error"), message: Text("Could not add color. Please paste something like this: #FFFF00"), dismissButton: .default(Text("OK")))

        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                if let selectedImage = image as? UIImage {
                    if self.imageOption == 1 {
                        let extractedColors = selectedImage.getColors()
                        self.pickedColors.append(contentsOf: [(extractedColors?.detail)!, (extractedColors?.background)!, (extractedColors?.primary)!, (extractedColors?.secondary)!])
                    } else {
                        self.selectedImage = selectedImage
                        self.gradientType = 4
                    }
                }
            }
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("What do you want to do?"), buttons: [
//                .default(Text("Generate background")) {
//                    self.showImagePicker.toggle()
//                    self.imageOption = 0
//                },
                .default(Text("Generate colors")) {
                    self.showImagePicker.toggle()
                    self.imageOption = 1
                },
                .default(Text("Dismiss"))
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    

struct MainButton: View {

    var imageName: String
    var colorHex: String

    var size: CGFloat = 50

    var body: some View {
        ZStack {
            Image(systemName: imageName)
            .resizable()
            .frame(width: self.size, height: self.size)
            .foregroundColor(.blue)
        }
    }
}

    enum NotificationType: String {
        case backgroundSaved = "Background saved"
        case colorPasted = "Your color 🎨 was pasted"
        case imagePasted = "Your image 🖼 was pasted"
    }
