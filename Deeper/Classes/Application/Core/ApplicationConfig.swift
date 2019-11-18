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
    let animation = BehaviorRelay<Bool>(value: true)
    
    public func set(animation: Bool) {
        self.animation.accept(animation)
    }
}
