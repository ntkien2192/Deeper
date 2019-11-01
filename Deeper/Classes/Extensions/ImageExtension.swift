//
//  Storyboard.swift
//  SOA
//
//  Created by Nguyễn Trung Kiên on 11/23/18.
//  Copyright © 2018 Whale Land. All rights reserved.
//

import UIKit

public extension UIImage {
    var base64: String? {
        return self.pngData()?.base64EncodedString()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var averageLuminance: CGFloat? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage,
                                                          kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [CIContextOption.workingColorSpace: kCFNull!])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0,
                                      width: 1, height: 1),
                       format: CIFormat.RGBA8,
                       colorSpace: nil)

        let r = CGFloat(bitmap[0]) / 255
        let g = CGFloat(bitmap[1]) / 255
        let b = CGFloat(bitmap[2]) / 255
        let luminance = 0.212 * r + 0.715 * g + 0.073 * b
        return luminance
    }
}
