//
//  Start.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/6/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public class Start: Application {
    
    let store = StartStore.share
    let viewModel = StartStore.share.viewModel.value
    
    public class func on() -> Start {
        let app = Start()
        return app
    }
    
    public func config(_ handle: ((ApplicationConfig) -> Void)? = nil) -> Start {
        handle?(StartStore.share.config.value)
        return self
    }
    
    public func bind(_ handle: ((StartViewModel) -> Void)? = nil) -> Start {
        handle?(StartStore.share.viewModel.value)
        return self
    }
    
    public func activity(_ handle: ((StartActivity) -> Void)? = nil) -> Start {
        _ = StartStore.share.viewModel.value.activity.on { activity in
            handle?(activity)
        }
        return self
    }
    
    override init() {
        super.init()
        let theme = Deeper.share.config.value.theme.value
        
        switch theme {
        case .hemera:
            let view = Storyboard.start.get(HemeraStartViewController.self)!
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
        
        _ = viewModel.activity.on({ activity in
            if activity == .callClose { self.state.accept(.close) }
        })
    }
    
    override func clearStore() {
        store.clear()
    }
}
