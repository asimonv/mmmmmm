//
//  ImageBlurredView.swift
//  ColorPicker
//
//  Created by Andre Simon on 19-06-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct ImageBlurredView: View {
    @Binding var selectedImage: UIImage?
    var body: some View {
        Image(uiImage: selectedImage!.resizeImage(targetSize: CGSize(width: 10, height: 15)))
        .resizable()
        .scaledToFill()
        .blur(radius: 5, opaque: true)
    }
}

struct ImageBlurredView_Previews: PreviewProvider {
    static var previews: some View {
        ImageBlurredView(selectedImage: Binding.constant(nil))
    }
}
