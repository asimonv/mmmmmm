//
//  ColorsView.swift
//  ColorPicker
//
//  Created by Andre Simon on 20-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct ColorsView: View {
    @Binding var pickedColors: [UIColor]
    var body: some View {
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
    }
}

struct ColorsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorsView(pickedColors: Binding.constant([.purple, .red, .cyan]))
    }
}
