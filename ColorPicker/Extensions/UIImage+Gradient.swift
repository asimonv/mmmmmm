//
//  UIImage+Gradient.swift
//  ColorPicker
//
//  Created by Andre Simon on 14-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import UIKit


func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
{
    let sepiaFilter = CIFilter(name:"CISepiaTone")
    sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
    sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
    return sepiaFilter?.outputImage
}

extension UIImage {
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
    
    func dithered(intensity: CGFloat) -> UIImage {
//        let ditherFilter = CIFilter(name: "CIDither")
//        ditherFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
//        ditherFilter?.setValue(CIImage(image: self), forKey: kCIInputImageKey)
//        return UIImage(ciImage: (ditherFilter?.outputImage!)!)
        guard let sepiaCIImage = sepiaFilter(CIImage(image: self)!, intensity:0.9) else { return UIImage(color: .black, size: self.size)! }
        return UIImage(ciImage: sepiaCIImage)
    }
}
