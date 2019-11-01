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
    
    public let store = StartStore.share
    
    public class func on() -> Start? {
        let app = Start()
        return app
    }
    
    public func bind(_ handle: ((StartStore) -> Void)? = nil) -> Start {
        handle?(store)
        return self
    }
    
    override init() {
        super.init()
        let theme = Deeper.share.theme
        
        switch theme {
        case .hemera:
            let view = Storyboard.start.get(HemeraStartViewController.self)!
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
        }
    }
    
    override func clearStore() {
        store.clear()
    }
}
