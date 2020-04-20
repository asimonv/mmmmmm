//
//  LinearGradientView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct LinearGradientView: View {
    @Binding var pickedColors: [UIColor]
    var body: some View {
        Rectangle()
        .fill(
            LinearGradient(gradient: Gradient(colors: pickedColors.map({ color in
                Color(color)
            })), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct LinearGradientView_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradientView(pickedColors: Binding.constant([]))
    }
}
