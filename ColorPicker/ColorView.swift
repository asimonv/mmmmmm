//
//  ColorView.swift
//  ColorPicker
//
//  Created by Andre Simon on 14-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct ColorView: View {
    var color: Color
    
    var body: some View {
        Circle()
            .overlay(
              Circle()
             .stroke(Color.white,lineWidth: 3)
            ).foregroundColor(color)
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView(color: .pink)
    }
}
