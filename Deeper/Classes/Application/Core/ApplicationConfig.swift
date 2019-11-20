//
//  ApplicationConfig.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/31/19.
//

import UIKit
import RxSwift
import RxCocoa

public class ApplicationConfig: NSObject {
    let presentAnimation = BehaviorRelay<Bool>(value: true)
    let screen = BehaviorRelay<ApplicationScreen>(value: ApplicationScreen())
    
    public func set(presentAnimation: Bool) {
        self.screen.value.presentAnimation.accept(presentAnimation)
    }
    
    public func set(screen: ApplicationScreen) {
        self.screen.accept(screen)
    }
}
