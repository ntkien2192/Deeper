//
//  Deeper.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/29/19.
//

import UIKit

public enum Theme: Int {
    case deeper = 0
}

extension Theme {
    init(_ index: Int) {
        switch index {
        case 0:
            self = .deeper
        default:
            self = .deeper
        }
    }
    
    var value: Int {
        switch self {
        case .deeper:
            return 0
        }
    }
}
