//
//  ActionsView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI


struct ActionsView: View {
    @State var open = false
    
    var shuffleAction: () -> Void
    var addColor: () -> Void
    var saveBackground: () -> Void
    var clearAction: () -> Void
    var pickImageAction: () -> Void

    var body: some View {
        ZStack {
            MenuItem(open: $open, icon: "trash", action: clearAction, offsetY: -90, color: .pink)
            MenuItem(open: $open, icon: "photo", action: pickImageAction, offsetX: -60, offsetY: -60, delay: 0.1, color: .blue)
            MenuItem(open: $open, icon: "shuffle", action: shuffleAction, offsetX: -80, delay: 0.2, color: .blue)
            MenuItem(open: $open, icon: "plus", action: addColor, offsetX: 60, offsetY: -60, delay: 0.3, color: .blue)
            MenuItem(open: $open, icon: "arrow.down.to.line", action: saveBackground, offsetX: 80, delay: 0.4, color: Color(hex: "#00b894"))

            Button(action: { self.open.toggle()}) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(open ? 45 : 0))
                    .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
            }
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 3))
            .padding([.horizontal], 5)
        }
    }
}

struct ActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsView(shuffleAction: {}, addColor: {}, saveBackground: {}, clearAction: {}, pickImageAction: {})
    }
}

struct MenuItem: View {
    @Binding var open: Bool
    
    var icon: String
    var action: () -> Void
    var offsetX: CGFloat = 0
    var offsetY: CGFloat  = 0
    var delay: Double = 0.0
    var color: Color = .white
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .font(.system(size: 16, weight: .bold))

        }
        .background(color)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.white, lineWidth: 3))
        .padding([.horizontal], 5)
        .shadow(radius: 5)
        .offset(x: open ? offsetX : 0, y: open ? offsetY : 0)
        .scaleEffect(open ? 1 : 0)
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(delay))
    }
}
