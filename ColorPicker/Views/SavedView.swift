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
    @Binding var notificationText: String
    
    var callback: () -> Void
    
    var body: some View {
        HStack {
            Text(notificationText).bold().foregroundColor(Color.white).font(.system(size: 20))
        }
        .padding([.horizontal], 40)
        .transition(.move(edge: .leading))
        .animation(.ripple())
        .onAppear(perform: callback)
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView(currentColor: Binding.constant(UIColor.black), notificationText: Binding.constant("Text"), callback: {})
    }
}
