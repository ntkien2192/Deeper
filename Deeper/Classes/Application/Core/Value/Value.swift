//
//  Object.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 6/11/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//enum ValueActivity {
//    case none
//    case detail
//}

enum ValueType {
    case none
    case string
    case unit
    case application
    case image
}

public class Value: NSObject {
//    let value = BehaviorRelay<Any?>(value: nil)
    let type = BehaviorRelay<ValueType>(value: .none)
//    let activity = BehaviorRelay<ValueActivity>(value: .none)
    
//    init(_ value: Any) {
//        self.value.accept(value)
//        if (value as? Unit) != nil {
//            self.type.accept(.unit)
//        }
//        
//        if (value as? Application) != nil {
//            self.type.accept(.application)
//        }
//        
//        if (value as? String) != nil {
//            self.type.accept(.string)
//        }
//    }
}
