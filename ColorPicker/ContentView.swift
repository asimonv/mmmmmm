	//
//  ContentView.swift
//  ColorPicker
//
//  Created by Andre Simon on 12-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI
    
    extension View {
        func asImage() -> UIImage {
            let controller = UIHostingController(rootView: self)

            // locate far out of screen
            controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
            UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

            let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.sizeToFit()

            let image = controller.view.asImage()
            controller.view.removeFromSuperview()
            return image
        }
    }

    extension UIView {
        func asImage() -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
    // [!!] Uncomment to clip resulting image
    //             rendererContext.cgContext.addPath(
    //                UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
    //            rendererContext.cgContext.clip()
                layer.render(in: rendererContext.cgContext)
            }
        }
    }


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
    
    func addColor() -> Void {
        pickedColors.insert(currentColor, at: 0)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GradientView(gradientType: $gradientType, pickedColors: $pickedColors, rotationValue: $rotationValue, centerPosition: $centerPosition)
            
            VStack(alignment: .leading) {
                ColorPickerView(chosenColor: $currentColor, isDragging: $isDragging)
                .frame(width: 50, height: 200).padding([.top], 80)
                
                if backgroundSaved {
                    HStack {
                        Rectangle().fill(Color(currentColor))
                        .cornerRadius(10)
                        .frame(width: 40, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2.0)
                        )
                        Text("Saved!").bold().foregroundColor(Color.white)
                    }
                    .padding(20)
                    .transition(.move(edge: .leading))
                    .animation(.ripple())
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.backgroundSaved = false
                            }
                        }
                    })
                    
                }
                    ZStack(alignment: .bottomTrailing) {
                        if !isDragging {
                            VStack(alignment: .trailing) {
                                Spacer().frame(maxWidth: .infinity)
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(pickedColors, id: \.self) { color in
                                            ColorView(color: Color(color))
                                            .frame(width: 30, height: 30)
                                            .padding(.all)
                                                .onTapGesture {
                                                    if self.pickedColors.count > 1 {
                                                        self.pickedColors.removeAll(where: { value in
                                                            color == value
                                                        })
                                                    }
                                                    
                                            }
                                        }
                                    }
                                    HStack(alignment: .center) {
                                        Button(action: { self.gradientType = (self.gradientType + 1) % 3 }) {
                                            Image(systemName: "shuffle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color.white.opacity(0.8))
                                                .padding(.all)
                                        }
                                        
                                        Button(action: addColor) {
                                            Image(systemName: "plus.app.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color.white.opacity(0.8))
                                                .padding(.all)

                                        }
                                        
                                        Button(action: saveBackground) {
                                            Image(systemName: "square.and.arrow.down.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color.white.opacity(0.8))
                                                .padding(.all)
                                        }
                                    }
                                }
                                .transition(.move(edge: .trailing))
                                .animation(.ripple())
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
                                
                            }
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
