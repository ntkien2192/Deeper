//
//  AppScreen.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/7/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum AppScreenType {
    case none
//    case object(Any?)
//    case view(View)
    case onNavigation(ViewController, hideNavigationBar: Bool)
//    case rawViewController(ViewController)
}

class Screen: NSObject {
    let id = BehaviorRelay<String>(value: UUID().uuidString)
    
    let type = BehaviorRelay<AppScreenType>(value: .none)
    
    let navigation = BehaviorRelay<NavigationController?>(value: nil)
    let viewController = BehaviorRelay<ViewController?>(value: nil)
    let view = BehaviorRelay<View?>(value: nil)
    let object = BehaviorRelay<Any?>(value: nil)
    let animation = BehaviorRelay<Bool>(value: true)
    
    init(_ type: AppScreenType) {
        super.init()
        self.type.accept(type)
        switch self.type.value {
//        case .object(let object):
//            self.object.accept(object)
        case .onNavigation(let viewController, let hideNavigationBar):
            self.navigation.accept(viewController.onNavigation(hideNavigationBar))
//        case .rawViewController(let viewController):
//                self.viewController.accept(viewController)
//        case .view(let view):
//            self.view.accept(view)
        default: break
        }
}
}
