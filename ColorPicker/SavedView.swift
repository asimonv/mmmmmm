//
//  SavedView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct SavedView: View {
    @Binding var currentColor: UIColor
    var callback: () -> Void
    var body: some View {
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
        .onAppear(perform: callback)
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView(currentColor: Binding.constant(UIColor.black), callback: {})
    }
}
