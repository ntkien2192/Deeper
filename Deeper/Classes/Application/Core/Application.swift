//
//  Application.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/5/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum AppType {
    case application
    case subFunction
}

enum AppState {
    case none
    case prepare
    case ready
    case background
    case active
    case close
    case closeThen(Application?)
    
    var detail: String {
        switch self {
        case .none:         return "      NONE"
        case .prepare:      return "   PREPARE"
        case .ready:        return "     READY"
        case .background:   return "BACKGROUND"
        case .active:       return "    ACTIVE"
        case .close:        return "     CLOSE"
        case .closeThen:    return "CLOSE THEN"
        }
    }
}

var _applicationStateData = [String: BehaviorRelay<AppState>]()

public class Application: NSObject {
    
    let id = BehaviorRelay<String>(value: UUID().uuidString)
    let type = BehaviorRelay<AppType>(value: .application)
    let screen = BehaviorRelay<Screen?>(value: nil)
    let subApplication = BehaviorRelay<[Application]>(value: [])
    
    var state: BehaviorRelay<AppState> {
        let temp = _applicationStateData[id.value] ?? BehaviorRelay<AppState>(value: .none)
        if _applicationStateData[id.value] == nil {
            _applicationStateData[id.value] = temp
        }
        return temp
    }
    
    func then(_ application: Application?) -> Application {
        if let application = application {
            subApplication.accept(subApplication.value.add(application))
        }
        return self
    }
    
    func prepare(_ screen: Screen) {
        self.screen.accept(screen)
    }
    
    func run() {
        _ = Deeper.open(self)
    }
    
    func wake() -> Observable<Any?> {
        return Observable.create({ [weak self] observer -> Disposable in
            switch self?.screen.value?.type.value ?? .none {
            case .onNavigation(let view, _):
                _ = view.waked().on(completed: {
                    observer.onCompleted()
                })
//            case .view(let view):
//                _ = view.wake().on(completed: {
//                    observer.onCompleted()
//                })
            default: break
            }
            return Disposables.create()
        })
    }
    
    func clearStore() {
        print("   │    │    └ [APP      CLEAR] ·········· [\(self.detail)]")
    }
}

extension Array where Element: Screen {
    
    func add(_ screen: Screen) -> [Screen] {
        return self + [screen]
    }
    
    func included(_ screen: Screen) -> Screen? {
        return first(where: { $0.id.value == screen.id.value })
    }
    
    func indexOf(_ screen: Screen) -> Int? {
        return firstIndex(where: { $0.id.value == screen.id.value })
    }
    
    func remove(_ screen: Screen) -> [Screen] {
        var temp = self
        if let index = indexOf(screen) {
            temp.remove(at: index)
        }
        return temp
    }
}

