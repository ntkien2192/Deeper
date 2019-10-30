//
//  Storyboard.swift
//  SOA
//
//  Created by Nguyễn Trung Kiên on 11/23/18.
//  Copyright © 2018 Whale Land. All rights reserved.
//

import UIKit

public enum Image: String {
    case deeperLogo = "DeeperLogo"
}

public extension Image {
    var value: UIImage? {
        let podBundle = Bundle(for: Deeper.self)
        guard let bundleURL = podBundle.url(forResource: "Deeper", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
            return nil
        }
        return UIImage(named: self.rawValue, in: bundle, compatibleWith: nil)
    }
}

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
}
