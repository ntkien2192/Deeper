//
//  Image.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/1/19.
//

import UIKit
import RxCocoa
import RxSwift

public class Image: Value {
    let image = BehaviorRelay<UIImage?>(value: nil)
    let imageUrl = BehaviorRelay<String?>(value: nil)
    let size = BehaviorRelay<CGSize?>(value: nil)
    
    public init(_ image: UIImage? = nil, imageUrl: String? = nil, size: CGSize? = nil) {
        super.init()
        self.type.accept(.image)
        self.image.accept(image)
        self.imageUrl.accept(imageUrl)
        self.size.accept(size ?? image?.size)
    }
}

public extension Image {
    enum assest: String {
        case logo = "Logo"
        
        public var value: UIImage? {
            let theme = Deeper.share.theme
            let podBundle = Bundle(for: Deeper.self)
            guard let bundleURL = podBundle.url(forResource: "Deeper", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
                return nil
            }
            return UIImage(named: theme.rawValue + "/" + self.rawValue, in: bundle, compatibleWith: nil)
        }
    }
}


