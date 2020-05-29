//
//  MenuItem.swift
//  ColorPicker
//
//  Created by Andre Simon on 29-05-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct MenuItem: View {
    var icon: String
    var action: () -> Void
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
    }
}
