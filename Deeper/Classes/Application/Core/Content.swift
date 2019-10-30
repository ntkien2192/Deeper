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

enum ContentType {
    case none
}

enum ContentStatus {
    case none
    case primary
    case secondary
    case success
    case warning
    case danger
    case info
    case disable
}

public class Content: NSObject {
    
    let value = BehaviorRelay<String?>(value: nil)
    let targets = BehaviorRelay<[String]>(value: [])
    
    let type = BehaviorRelay<ContentType>(value: .none)
    let status = BehaviorRelay<ContentStatus>(value: .none)
    
    init(_ value: String = "", targets: [String] = [], type: ContentType = .none, status: ContentStatus = .none) {
        self.value.accept(value)
        self.targets.accept(targets)
        self.type.accept(type)
        self.status.accept(status)
    }
    
    var attributedValue: NSMutableAttributedString {
        let strings = NSMutableAttributedString()
        let content = self.value.value ?? ""
        
//        switch (type.value, status.value) {
//        case (.title, _):
//            strings.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2470588235, green: 0.2509803922, blue: 0.2784313725, alpha: 1) as Any]))
//            targets.value.forEach { target in
//                if let range = content.range(of: target) {
//                    strings.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.06274509804, green: 0.7333333333, blue: 0.5294117647, alpha: 1) as Any], range: content.nsRange(from: range))
//                }
//            }
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
