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
    
    private let store = StartStore.share
    private let viewModel = StartStore.share.viewModel.value
    
    public class func on() -> Start {
        let app = Start()
        return app
    }
    
    public func config(_ handle: ((ApplicationConfig) -> Void)? = nil) -> Start {
        handle?(self.config.value)
        return self
    }
    
    public func bind(_ handle: ((StartViewModel) -> Void)? = nil) -> Start {
        handle?(viewModel)
        return self
    }
    
    public func activity(_ handle: ((StartActivity) -> Void)? = nil) -> Start {
        _ = viewModel.activity.on { activity in
            handle?(activity)
        }
        return self
    }
    
    override init() {
        super.init()
        
        let view = DeeperKit.start.onNavigation(hideNavigationBar: true)
        
        _ = config { config in
            let screen = ApplicationScreen(view)
            config.set(screen: screen)
            config.set(presentAnimation: false)
        }
        
        _ = activity { activity in
            if activity == .callClose { self.state.accept(.close) }
        }
    }
    
    override func clearStore() {
        store.clear()
    }
}
