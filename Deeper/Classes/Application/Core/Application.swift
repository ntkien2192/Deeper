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

public enum AppState {
    case none
    case prepare
    case ready
    case background
    case active
    case close
    case closeThen(Application?)
    case clear
    
    var detail: String {
        switch self {
        case .none:         return "      NONE"
        case .prepare:      return "   PREPARE"
        case .ready:        return "     READY"
        case .background:   return "BACKGROUND"
        case .active:       return "    ACTIVE"
        case .close:        return "     CLOSE"
        case .closeThen:    return "CLOSE THEN"
        case .clear:        return "     CLEAR"
        }
    }
}

var _applicationStateData = [String: BehaviorRelay<AppState>]()

public class Application: NSObject {
    
    let type = BehaviorRelay<AppType>(value: .application)
    let subApplication = BehaviorRelay<[Application]>(value: [])
    let config = BehaviorRelay<ApplicationConfig>(value: ApplicationConfig())
    
    var state: BehaviorRelay<AppState> {
        let temp = _applicationStateData[self.address] ?? BehaviorRelay<AppState>(value: .none)
        if _applicationStateData[self.address] == nil {
            _applicationStateData[self.address] = temp
        }
        return temp
    }
    
    func then(_ application: Application?) -> Application {
        if let application = application {
            subApplication.accept(subApplication.value.add(application))
        }
        return self
    }
    
    func run() {
        _ = Deeper.share.open(self)
    }
    
    func waked() -> Observable<Any?> {
        return Observable.create({ [weak self] observer -> Disposable in
            _ = self?.config.value.screen.value.state({ state in
                if state == .open {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    func clearStore() {
        print("   │    │    └ [APP      CLEAR] ·········· [\(self.detail)]")
    }
}

extension Array where Element: Application {
    func add(_ application: Application) -> [Application] {
        return self + [application]
    }
    
    func included(_ application: Application) -> Application? {
        return first(where: { $0.address == application.address })
    }
    
    func indexOf(_ application: Application) -> Int? {
        return firstIndex(where: { $0.address == application.address })
    }
    
    func remove(_ application: Application) -> [Application] {
        var temp = self
        if let index = indexOf(application) {
            temp.remove(at: index)
        }
        return temp
    }
}
