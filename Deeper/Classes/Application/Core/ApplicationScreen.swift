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

public enum ApplicationScreenState {
    case none
    case open
    case close
}

public class ApplicationScreen: NSObject {
    
    let view = BehaviorRelay<Any>(value: NSObject())
    let presentAnimation = BehaviorRelay<Bool>(value: true)
    private let state = BehaviorRelay<ApplicationScreenState>(value: .none)
    
    override init() {}
    
    init(_ view: Any) {
        self.view.accept(view)
    }
    
    public func state(_ handle: ((ApplicationScreenState) -> Void)? = nil) -> ApplicationScreen {
        _ = state.on { state in
            handle?(state)
        }
        return self
    }
    
    func open(_ handle: Handle = nil) {
        func openScreen() {
            if let view = self.view.value as? View {
                view.present(animated: self.presentAnimation.value, handle: { [weak self] in
                    handle?()
                    self?.state.accept(.open)
                })
                return
            }
            if let view = self.view.value as? ViewController {
                print("   │    │    │    └ [CONTROLLER  SHOW] ··· [\(view.detail)]")
                view.present(animated: self.presentAnimation.value, handle: { [weak self] in
                    handle?()
                    self?.state.accept(.open)
                })
                return
            }
            if let view = self.view.value as? NavigationController {
                print("   │    │    │    └ [CONTROLLER  SHOW] ··· [\(view.detail)]")
                view.present(animated: self.presentAnimation.value, handle: { [weak self] in
                    handle?()
                    self?.state.accept(.open)
                })
                return
            }
        }
        
        let queue = TaskQueue()
        queue.tasks +=! {
            openScreen()
        }
        queue.run()
    }

    func close(_ handle: Handle = nil) {
        func closeScreen() {
            if let view = self.view.value as? View {
                view.dismiss(animated: self.presentAnimation.value, handle: { [weak self] in
                    handle?()
                    self?.state.accept(.close)
                })
                return
            }
            if let view = self.view.value as? ViewController {
                view.dismiss(animated: self.presentAnimation.value, handle: { [weak self] in
                    handle?()
                    self?.state.accept(.close)
                    print("   │    │    │    └ [CONTROLLER ENDED] ··· [\(self?.detail ?? "")]")
                })
                return
            }
            if let view = self.view.value as? NavigationController {
                view.dismiss(animated: self.presentAnimation.value, handle: { [weak self] in
                    handle?()
                    self?.state.accept(.close)
                    print("   │    │    │    └ [CONTROLLER ENDED] ··· [\(self?.detail ?? "")]")
                })
                return
            }
        }
        
        let queue = TaskQueue()
        queue.tasks +=! {
            closeScreen()
        }
        queue.run()
    }
}
