//
//  BaseModel.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 5/7/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension StringProtocol {
    func nsRange(from range: Range<Index>) -> NSRange {
        return .init(range, in: self)
    }
}

extension NSObject {
    var name: String {
        return String(describing: self)
    }

    var address: String {
        return String(format: "%p", unsafeBitCast(self, to: Int.self))
    }
    
    var detail: String {
        return "\(type(of: self)) · \(address)"
    }
    
    var className: String {
        return "\(type(of: self))"
    }
}

extension CGFloat {
    func bound(max: CGFloat, min: CGFloat, isUpSideDown: Bool = false) -> CGFloat {
        if isUpSideDown {
            return -(self - max) > max ? max : (-(self - max) < min ? min : -(self - max))
        }
        return self > max ? max : (self < min ? min : self)
    }
}

extension NSMutableAttributedString {
    func add(string: String, textColor: UIColor? = nil, font: UIFont? = nil) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: string, attributes:
            [NSAttributedString.Key.foregroundColor: textColor as Any, NSAttributedString.Key.font: font as Any]))
        return self
    }
    
    func add(targets: [String], textColor: UIColor? = nil, font: UIFont? = nil) -> NSMutableAttributedString {
        let content = self.string
        targets.forEach { target in
            if let range = content.range(of: target) {
                self.addAttributes([NSAttributedString.Key.foregroundColor: textColor as Any,
                NSAttributedString.Key.font: font as Any], range: content.nsRange(from: range))
            }
        }
        return self
    }
}
