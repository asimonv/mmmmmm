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
            ForEach(pickedColors.indices, id: \.self) { idx in
                ColorView(color: Color(self.pickedColors[idx]))
                .frame(width: 30, height: 30)
                .padding(.all)
                .onTapGesture {
                    self.pickedColors.remove(at: idx)
                }
            }
        }
    }
}

struct ColorsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorsView(pickedColors: Binding.constant([]))
    }
}
