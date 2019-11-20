//
//  AppQueue.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/5/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum BusinessQueueState {
    case none
    case prepare
    case ready
    case active
    case close
    
    var detail: String {
        switch self {
        case .none:
            return "   NONE"
        case .prepare:
            return "PREPARE"
        case .ready:
            return "  READY"
        case .active:
            return " ACTIVE"
        case .close:
            return "  CLOSE"
        }
    }
}

public class BusinessQueue: NSObject {
    let id = BehaviorRelay<String>(value: UUID().uuidString)
    let applications = BehaviorRelay<[Application]>(value: [])
    let state = BehaviorRelay<BusinessQueueState>(value: .none)
    let isActive = BehaviorRelay<Bool>(value: false)
    let isSubQueue = BehaviorRelay<Bool>(value: false)
    
    override init() {
        super.init()
        _ = applications.on { [weak self] applications in
            self?.isSubQueue.accept(applications.filter({ $0.type.value == .application }).count == 0)
        }
    }
    
    public func open(_ application: Application?, handle: Handle = nil) -> BusinessQueue {
        if let application = application {
            
            if let application = self.applications.value.included(application) {
                application.state.accept(.active)
            } else {
//                _ = application.activity.on { activity in
//                    switch activity {
//                    case .callRoadmap(let state):
//                        switch state {
//                        case .active:
//                            TipPresenter.openTip(application)
//                        case .close:
//                            TipPresenter.closeTip(application)
//                        default: break
//                        }
//                    case .callHelp(let value):
//                        print("   │    │    └ [APP  CALL HELP] ·········· [\(value?.detail ?? "")]")
//                    default: break
//                    }
//                }
                
                _ = application.state.on ({ [weak self] state in
                    switch state {
                    case .active:
                        print("   │    │    └ [APP \(state.detail)] ┐········· [\(application.detail)]")
                        print("   │    │    │    ┌─────────────┘")
                    default:
                        print("   │    │    └ [APP \(state.detail)] ·········· [\(application.detail)]")
                    }
                    
                    switch state {
                    case .prepare:
                        self?.applications.accept(self?.applications.value.add(application) ?? [])
                        application.state.accept(.ready)
                    case .ready:
                        application.state.accept(.background)
                        handle?()
                    case .active:
                        application.config.value.screen.value.open()
                    case .closeThen(let app):
                        _ = self?.open(app, handle: {
                            application.state.accept(.close)
                        })
                    case .close:
                        if application.subApplication.value.count != 0 {
                            application.subApplication.value.forEach { application in
                                application.state.accept(.close)
                            }
                        }
                        application.config.value.screen.value.close {
                            application.state.accept(.clear)
                        }
                    case .clear:
                        application.clearStore()
                        self?.applications.accept(self?.applications.value.remove(application) ?? [])
                        self?.run()
                    default: break
                    }
                })
                
                application.state.accept(.prepare)
            }
        }
        return self
    }
    
    func run() {
        if let application = applications.value.first {
            print("   │    └ [QUEUE   START] ┐··············· [\(self.detail)]")
            print("   │    │    ┌────────────┘")
            application.state.accept(.active)
            _ = application.waked().on(completed: {
                if let subApplication = application.subApplication.value.first {
                    subApplication.run()
                }
            })
        } else {
            print("   │    └ [QUEUE   EMPTY] ················ [\(self.detail)]")
            state.accept(.close)
        }
    }
}
