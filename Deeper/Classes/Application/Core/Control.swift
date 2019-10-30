//
//  Control.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 5/29/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum ControlType {
    case none
    case title
    case subTitle
    case info
    case button
    case field
//    case text
    case targetValue
}

enum ControlStatus {
    case none
    case primary
    case secondary
    case success
    case warning
    case danger
    case info
    case disable
}

class Control: NSObject {
    let type = BehaviorRelay<ControlType>(value: .none)
    let status = BehaviorRelay<ControlStatus>(value: .none)
    let content = BehaviorRelay<Content?>(value: nil)
    var contentValue: Content? {
        return content.value
    }
    let value = BehaviorRelay<Value?>(value: nil)
    
    let color = BehaviorRelay<UIColor>(value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let backgroundColor = BehaviorRelay<UIColor>(value: #colorLiteral(red: 0.3607843137, green: 0.4705882353, blue: 1, alpha: 1))
    let shadowColor = BehaviorRelay<UIColor>(value: #colorLiteral(red: 0.3607843137, green: 0.4705882353, blue: 1, alpha: 1))
    
    var handle: Handle = nil
    
    class func on(_ value: Value, isShow: Bool = true, handle: Handle = nil) -> Control? {
        if isShow {
            let control = Control()
            control.value.accept(value)
            control.type.accept(.targetValue)
            control.handle = handle
            return control
        }
        return nil
    }
    
    class func on(_ content: Content, type: ControlType = .button, status: ControlStatus = .none, isShow: Bool = true, handle: Handle = nil) -> Control? {
        if isShow {
            let control = Control()
            control.content.accept(content)
            control.type.accept(type)
            control.status.accept(status)
            
            switch (type, status) {
            case (.button, .none):
                control.backgroundColor.accept(UIColor.fWhite)
                control.shadowColor.accept(UIColor.fWhite)
                control.color.accept(UIColor.fTextStrong)
            case (.button, .primary):
                control.backgroundColor.accept(UIColor.fBlue)
                control.shadowColor.accept(UIColor.fBlueShadow)
                control.color.accept(UIColor.fWhite)
            case (.button, .secondary):
                control.backgroundColor.accept(UIColor.fBlack)
                control.shadowColor.accept(UIColor.fBlackShadow)
                control.color.accept(UIColor.fBorder)
            case (.button, .success):
                control.backgroundColor.accept(UIColor.fGreen)
                control.shadowColor.accept(UIColor.fGreenShadow)
                control.color.accept(UIColor.fWhite)
            case(.button, .info):
                control.backgroundColor.accept(UIColor.fLight)
                control.shadowColor.accept(UIColor.fLightShadow)
                control.color.accept(UIColor.fTextStrong)
            case (.button, .warning):
                control.backgroundColor.accept(UIColor.fYellow)
                control.shadowColor.accept(UIColor.fYellowShadow)
                control.color.accept(UIColor.fTextStrong)
            case (.button, .danger):
                control.backgroundColor.accept(UIColor.fRed)
                control.shadowColor.accept(UIColor.fRedShadow)
                control.color.accept(UIColor.fWhite)
            case (.button, .disable):
                control.backgroundColor.accept(UIColor.fLight)
                control.shadowColor.accept(UIColor.fClear)
                control.color.accept(UIColor.fLightShadow)
                
                
//            case (.text, .none):
//                control.backgroundColor.accept(UIColor.fWhite)
//                control.color.accept(UIColor.fTextRegular)
//            case (.text, .primary):
//                control.backgroundColor.accept(UIColor.fBlue)
//                control.color.accept(UIColor.fWhite)
//            case (.text, .secondary):
//                control.backgroundColor.accept(UIColor.fLight)
//                control.color.accept(UIColor.fBlue)
//            case (.text, .success):
//                control.backgroundColor.accept(UIColor.fGreen)
//                control.color.accept(UIColor.fWhite)
//            case(.text, .info):
//                control.backgroundColor.accept(UIColor.fLight)
//                control.color.accept(UIColor.fTextStrong)
//            case (.text, .warning):
//                control.backgroundColor.accept(UIColor.fYellow)
//                control.color.accept(UIColor.fTextStrong)
//            case (.text, .danger):
//                control.backgroundColor.accept(UIColor.fRed)
//                control.color.accept(UIColor.fWhite)
//            case (.text, .disable):
//                control.backgroundColor.accept(UIColor.fRed)
//                control.color.accept(UIColor.fWhite)
            default: break
            }
         
            control.handle = handle
            
            return control
        }
        return nil
    }
}

class ControlGroup: NSObject {
    let canSkip = BehaviorRelay<Bool>(value: true)
    let controls = BehaviorRelay<[Control]?>(value: nil)
    
    init(canSkip: Bool = true) {
        self.canSkip.accept(canSkip)
    }
    
    func add(_ control: Control?) -> ControlGroup {
        if let control = control {
            self.controls.accept((controls.value ?? []) + [control])
        }
        return self
    }
    
    func on(_ handle: (Control) -> Void) {
        if let controls = controls.value {
            controls.forEach { control in
                handle(control)
            }
        }
    }
}
