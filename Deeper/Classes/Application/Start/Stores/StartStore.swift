//
//  WelcomeStore.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 9/8/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class StartStore: Store {
    private struct store { static var instance: StartStore? }
    func clear() { StartStore.store.instance = nil }
    
    class var share: StartStore {
        let value = store.instance ?? StartStore()
        if store.instance == nil {
            store.instance = value
        }
        return value
    }
    
    public let config = BehaviorRelay<ApplicationConfig>(value: ApplicationConfig())
    public let viewModel = BehaviorRelay<StartViewModel>(value: StartViewModel())
    
    public override init() {
        super.init()
        config.value.animation.accept(false)
    }
    
}
