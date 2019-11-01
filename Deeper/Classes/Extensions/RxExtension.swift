//
//  RxExtension.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/5/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum BehaviorRelayType {
    case singleSync
    case singleASync
    case multiSync
    case multiASync
}

var behaviorRelayStore = [String: Disposable]()

extension BehaviorRelay {
    var address: String { return String(format: "%p", unsafeBitCast(self, to: Int.self)) }
    
    func on(type: BehaviorRelayType = .multiASync, _ next: @escaping (Element) -> Void) -> Disposable {
        switch type {
        case .multiSync:
            return self.bind(onNext: next)
        case .multiASync:
            return self.observeOn(MainScheduler.asyncInstance).bind(onNext: next)
        case .singleSync:
            behaviorRelayStore[self.address]?.dispose()
            let newValue = self.bind(onNext: next)
            behaviorRelayStore[self.address] = self.bind(onNext: next)
            return newValue
        case .singleASync:
            behaviorRelayStore[self.address]?.dispose()
            let newValue = self.bind(onNext: next)
            behaviorRelayStore[self.address] = self.observeOn(MainScheduler.asyncInstance).bind(onNext: next)
            return newValue
        }
    }
    
    func to<O>(_ observer: O?) -> RxSwift.Disposable where O : RxSwift.ObserverType, BehaviorRelay.Element == O.Element {
        return self.on(type: .singleSync) { value in
            observer?.onNext(value)
        }
    }
    
    func to(_ relay: BehaviorRelay<Element>) -> Disposable {
        return self.on(type: .singleSync) { value in
            relay.accept(value)
        }
    }
}


enum ObservableType {
    case singleSync
    case singleASync
    case multiSync
    case multiASync
}

var observableStore = [String: Disposable]()

extension Observable {
    var address: String { return String(format: "%p", unsafeBitCast(self, to: Int.self)) }
    
    func on(type: BehaviorRelayType = .multiASync, _ next: @escaping ((Element) -> Void) = { _ in}, help: @escaping ((Error) -> Void) = { _ in}, completed: @escaping (() -> Void) = { }) -> Disposable {
        switch type {
        case .multiSync:
            return self.subscribe(onNext: next, onError: help, onCompleted: completed)
        case .multiASync:
            return self.observeOn(MainScheduler.asyncInstance).subscribe(onNext: next, onError: help, onCompleted: completed)
        case .singleSync:
            observableStore[self.address]?.dispose()
            let newValue = self.bind(onNext: next)
            observableStore[self.address] = self.subscribe(onNext: next, onError: help, onCompleted: completed)
            return newValue
        case .singleASync:
            observableStore[self.address]?.dispose()
            let newValue = self.bind(onNext: next)
            observableStore[self.address] = self.observeOn(MainScheduler.asyncInstance).subscribe(onNext: next, onError: help, onCompleted: completed)
            return newValue
        }
    }
    
    func to<O>(_ observer: O?) -> RxSwift.Disposable where O : RxSwift.ObserverType, Observable.Element == O.Element {
        return self.on(type: .singleSync, { value in
            observer?.onNext(value)
        })
    }
    
    func to(_ relay: BehaviorRelay<Element>) -> Disposable {
        return self.on(type: .singleSync, { value in
            relay.accept(value)
        })
    }
}
