//
//  ActionsView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI


struct ActionsView: View {
    @Binding var pickedColors: [UIColor]
    
    var shuffleAction: () -> Void
    var addColor: () -> Void
    var saveBackground: () -> Void
    var clearAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Button(action: clearAction) {
                Image(systemName: "clear.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.all)
            }
            
            Button(action: shuffleAction) {
                Image(systemName: "shuffle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.all)
            }.disabled(pickedColors.count <= 1)
            
            Button(action: addColor) {
                Image(systemName: "plus.app.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.all)

            }
            
            Button(action: saveBackground) {
                Image(systemName: "square.and.arrow.down.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.all)
            }
        }
    }
}

struct ActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsView(pickedColors: Binding.constant([]), shuffleAction: {}, addColor: {}, saveBackground: {}, clearAction: {})
    }
}
