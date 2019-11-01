//
//  Storyboard.swift
//  SOA
//
//  Created by Nguyễn Trung Kiên on 11/23/18.
//  Copyright © 2018 Whale Land. All rights reserved.
//

import UIKit

public enum Font: String {
    case notoSansJP = "NotoSansJP"
}

public extension Font {
    static func register(for fonts: [String]) {
        let podBundle = Bundle(for: Deeper.self)
        guard let bundleURL = podBundle.url(forResource: "Deeper", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
            return
        }
        fonts.forEach { font in
            UIFont.registerFont(withName: font, fileExtension: "otf", bundle: bundle)
        }
    }
}

extension UIFont {
    static func registerFont(withName name: String, fileExtension: String, bundle: Bundle) {
        guard let pathForResourceString = bundle.path(forResource: name, ofType: fileExtension) else { return }
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else { return }
        guard let dataProvider = CGDataProvider(data: fontData) else { return }
        let fontRef = CGFont(dataProvider)
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            print("Error registering font")
        }
    }
}
