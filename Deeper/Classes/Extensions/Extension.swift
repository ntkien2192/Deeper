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

//extension StringProtocol {
//    func nsRange(from range: Range<Index>) -> NSRange {
//        return .init(range, in: self)
//    }
//}

extension NSObject {
    static var name: String {
        return String(describing: self)
    }

    var address: String {
        return String(format: "%p", unsafeBitCast(self, to: Int.self))
    }
    
    var detail: String {
        return "\(type(of: self)) · \(address)"
    }
}

extension CGFloat {
    func bound(max: CGFloat, min: CGFloat, isUpSide: Bool = false) -> CGFloat {
        if isUpSide {
            return -(self - max) > max ? max : (-(self - max) < min ? min : -(self - max))
        }
        return self > max ? max : (self < min ? min : self)
    }
}

extension String {
    var json: Json? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        do { return try Json(data: data) } catch { return nil }
    }
    
    func toJson(_ key: String = "value") -> Json? {
        return "{\"\(key)\":\"\(self)\"}".json
    }
}
