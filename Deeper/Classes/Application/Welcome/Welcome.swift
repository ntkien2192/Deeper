//
//  Welcome.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/3/19.
//

import UIKit
import RxCocoa
import RxSwift

public class Welcome: Application {
    
    public let store = WelcomeStore.share
    
    public class func on() -> Welcome? {
        let app = Welcome()
        return app
    }
    
    public func config(_ handle: ((WelcomeStore ) -> Void)? = nil) -> Welcome {
        handle?(store)
        return self
    }
    
    public func bind(_ handle: ((AppState) -> Void)? = nil) -> Welcome {
        _ = state.on { state in
            handle?(state)
        }
        return self
    }
    
    override init() {
        super.init()
        let theme = Deeper.share.config.value.theme.value
        
        switch theme {
        case .hemera:
            let view = Storyboard.welcome.get(HemeraWelcomeViewController.self)!
            _ = view.viewModel.activity.on { [weak self] activity in
                if activity == .callClose {
                    self?.state.accept(.close)
                }
            }
            let screen = Screen(.onNavigation(view, hideNavigationBar: true))
            _ = store.config.value.animation.to(screen.animation)
            prepare(screen)
        case .erebus:
            let view = Storyboard.start.get(ErebusStartViewController.self)!
            let screen = Screen(.onNavigation(view, hideNavigationBar: true))
            _ = store.config.value.animation.to(screen.animation)
            prepare(screen)
        default: break
        }
    }
    
    override func clearStore() {
        store.clear()
    }
}
