//
//  Title.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 5/30/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public enum ContentDisplayType {
    case body
    case info
}

public enum ContentStatus {
    case primary
    case secondary
    case success
    case warning
    case danger
    case disable
}

public class Content: Value {
    
    let value = BehaviorRelay<String?>(value: nil)
    let targets = BehaviorRelay<[String]>(value: [])
    let displayType = BehaviorRelay<ContentDisplayType>(value: .body)
    let status = BehaviorRelay<ContentStatus>(value: .primary)
    
    public init(_ value: String = "", targets: [String] = [], displayType: ContentDisplayType = .body, status: ContentStatus = .primary) {
        self.value.accept(value)
        self.targets.accept(targets)
        self.displayType.accept(displayType)
        self.status.accept(status)
    }
    
    var attributedValue: NSMutableAttributedString {
        let theme = Deeper.share.theme
        let strings = NSMutableAttributedString()
        let content = self.value.value ?? ""
        
        switch (theme, displayType.value, status.value) {
        case (.hemera, .info, .primary):
            _ = strings
                .add(string: content,textColor: UIColor.hemera.textDark,
                     font: UIFont(name: UIFont.hemera.font.regular, size: 10))
                .add(targets: targets.value, textColor: UIColor.hemera.blue,
                     font: UIFont(name: UIFont.hemera.font.bold, size: 10))
        default: break
        }
//        case (.subtitle, _):
//            strings.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3490196078, green: 0.3647058824, blue: 0.431372549, alpha: 1) as Any]))
//            targets.value.forEach { target in
//                if let range = content.range(of: target) {
//                    strings.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2823529412, green: 0.2745098039, blue: 0.3568627451, alpha: 1) as Any], range: content.nsRange(from: range))
//                }
//            }
//        case (.info, _):
//            strings.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3490196078, green: 0.3647058824, blue: 0.431372549, alpha: 1) as Any]))
//            targets.value.forEach { target in
//                if let range = content.range(of: target) {
//                    strings.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2823529412, green: 0.2745098039, blue: 0.3568627451, alpha: 1) as Any,
//                                           NSAttributedString.Key.font: UIFont(name: fontBold, size: fontInfoSize) as Any], range: content.nsRange(from: range))
//                }
//            }
//        case (.helper, _):
//            strings.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3490196078, green: 0.3647058824, blue: 0.431372549, alpha: 1) as Any]))
//            targets.value.forEach { target in
//                if let range = content.range(of: target) {
//                    strings.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2823529412, green: 0.2745098039, blue: 0.3568627451, alpha: 1) as Any,
//                                           NSAttributedString.Key.font: UIFont(name: fontBold, size: fontSubTitleSize) as Any], range: content.nsRange(from: range))
//                }
//            }
//            strings.addEnd("Help".value)
//        case (.option, .primary):
//            strings.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3490196078, green: 0.3647058824, blue: 0.431372549, alpha: 1) as Any]))
//            targets.value.forEach { target in
//                if let range = content.range(of: target) {
//                    strings.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3450980392, green: 0.4039215686, blue: 0.8666666667, alpha: 1) as Any,
//                                           NSAttributedString.Key.font: UIFont(name: fontBold, size: fontControlSize) as Any], range: content.nsRange(from: range))
//                }
//            }
//        default: break
//        }
        return strings
    }
    
    var rawValue: String {
        return self.value.value ?? ""
    }
    
    class func paste() -> String? {
        return UIPasteboard.general.string
    }
}
