//
//  StringExtension.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/9/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit

extension String {
//    var value: String {
//        return self.localized()
//    }
//
    var image: UIImage? {
        if let data = Data(base64Encoded: self) {
            return UIImage(data: data)
        }
        return nil
    }
//    
//    func toColor(_ color: UIColor) -> NSAttributedString {
//        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color as Any])
//    }
//    
//    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        
//        return ceil(boundingBox.height)
//    }
//    
//    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        return ceil(boundingBox.width)
//    }
//    
//    func width(of font: UIFont) -> CGFloat{
//        let attributes = [NSAttributedString.Key.font : font]
//        let sizeOfText = (self as NSString).size(withAttributes: attributes)
//        return sizeOfText.width
//    }
}

//extension NSMutableAttributedString {
//    func addEnd(_ target: String, color: UIColor = #colorLiteral(red: 0.04493599385, green: 0.6627394557, blue: 0.4783084393, alpha: 1)) {
//        self.append(NSAttributedString(string: " "))
//        self.append(NSAttributedString(string: target, attributes: [NSAttributedString.Key.font: UIFont(name: "Noto Sans JP Bold", size: 14) as Any,
//                                                                       NSAttributedString.Key.foregroundColor: color as Any, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]))
//    }
//}
//
//extension Optional where Wrapped == String {
//  var isEmpty: Bool {
//    return (self ?? "").isEmpty
//  }
//}
