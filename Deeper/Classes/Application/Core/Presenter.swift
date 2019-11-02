//
//  Presenter.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/5/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Presenter: NSObject {
    static let share: Presenter = {
        let instance = Presenter()
        return instance
    }()
    
    class func open(_ application: Application, handle: Handle = nil) {
        let queue = TaskQueue()
        queue.tasks +=! {
            if let screen = application.screen.value {
                switch screen.type.value {
//                case .object(let object):
//                    if let view = object as? ImagePickerController {
//                        view.present(handle: handle)
//                        return
//                    }
                case .onNavigation:
                    screen.navigation.value?.presenterPresent(animated: screen.animation.value, handle: handle)
                    return
                    
                    
                    
//                case .rawViewController:
//                    if let view = screen.viewController.value {
//                        view.present(handle: handle)
//                        return
//                    }
//                case .view:
//                    if let view = screen.view.value {
//                        view.present(handle: handle)
//                        return
//                    }
                default: break
                }
                application.state.accept(.close)
                handle?()
            }
        }
        queue.run()
    }
    
    class func close(_ application: Application, handle: Handle = nil) {
        let queue = TaskQueue()
        queue.tasks +=! {
            if let screen = application.screen.value {
                switch screen.type.value {
//                case .object(let object):
//                    if let view = object as? ImagePickerController {
//                        view.dismiss(handle: handle)
//                    }
                case .onNavigation:
                    screen.navigation.value?.presenterDismiss(handle: handle)
//                case .rawViewController:
//                    if let view = screen.viewController.value {
//                        view.dismiss(handle: handle)
//                    }
//                case .view:
//                    if let view = screen.view.value {
//                        view.dismiss(handle: handle)
//                    }
                default: break
                }
            }
        }
        queue.run()
    }
}
