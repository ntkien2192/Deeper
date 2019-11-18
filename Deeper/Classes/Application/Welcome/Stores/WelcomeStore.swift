//
//  WelcomeStore.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/3/19.
//

import UIKit
import RxSwift
import RxCocoa

public class WelcomeStore: Store {
    private struct store { static var instance: WelcomeStore? }
    func clear() { WelcomeStore.store.instance = nil }
    
    class var share: WelcomeStore {
        let value = store.instance ?? WelcomeStore()
        if store.instance == nil {
            store.instance = value
        }
        return value
    }
    
    public let config = BehaviorRelay<WelcomeConfig>(value: WelcomeConfig())
    public let viewModel = BehaviorRelay<WelcomeViewModel>(value: WelcomeViewModel())
}
