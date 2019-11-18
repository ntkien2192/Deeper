//
//  Deeper.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/29/19.
//

import UIKit

public enum Theme: String {
    case none = ""
    case hemera = "Hemera"
    case erebus = "Erebus"
    
    public func setup() {
        switch self {
        case .hemera:
            Font.register(for: ["NotoSansJP-Bold", "NotoSansJP-Regular"])
        case .erebus:
            Font.register(for: ["NotoSansJP-Black"])
        default: break
        }
    }
}

public extension Theme {
    var value: Int {
        switch self {
        case .hemera: return 0
        case .erebus: return 1
        default: return -1
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .hemera: return UIColor.hemera.background
        case .erebus: return UIColor.erebus.background
        default: return UIColor.white
        }
    }
}

