//
//  Deeper.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/29/19.
//

import UIKit
import RxSwift
import RxCocoa

public class Deeper: NSObject {
    static let share: Deeper = { return Deeper() }()
    
    let store = BehaviorRelay<Store>(value: Store())
    let config = BehaviorRelay<DeeperConfig>(value: DeeperConfig())
    let queues = BehaviorRelay<[BusinessQueue]>(value: [])
    
    let statusBarStyle = BehaviorRelay<Any?>(value: nil)

    override init() {
        super.init()
        print("[DEEPER  PREPARE] ┐")
        print("   ┌──────────────┘")
        print("   └ [THEME   PREPARE] ┐")
        print("   ┌───────────────────┘")
        print("   └ [APPPUSH PREPARE] ┐·················· [\(self.detail)]")
        print("   ┌───────────────────┘")
        print("   └ [WINDOW  PREPARE] ┐")
        print("   │    ┬    ┬    ┌────┘")
    }
    
    public class func on(_ window: UIWindow?, _ preparedHandle: DeeperHandle) {
        
        let deeper = Deeper.share
        
        guard let window = window, let rootView = window.rootViewController else { return }
        Window.share = window
        
        _ = rootView.waked().on(completed: {
            
            _ = deeper.config.value.theme.on { theme in
                theme.setup()
                rootView.view.backgroundColor = theme.backgroundColor
            }
            
            print("   └──────────────┘\n")
            print("[DEEPER    START] ┐")
            print("   ┌──────────────┘")
            print("   └ [APPPUSH PREPARE] ┐·················· [\(Deeper.share.detail)]")
            print("   │    ┌──────────────┘")
            preparedHandle?(deeper)
        })
    }
    
    public func bind(_ handle: StoreHandle = nil) -> Deeper {
        handle?(self.store.value)
        return self
    }
    
    public func config(_ handle: DeeperConfigHandle = nil) -> Deeper {
        handle?(self.config.value)
        return self
    }

    
    func run() {
        if let queue = queues.value.first {
            print("   └ [APPPUSH   START] ··················· [\(self.detail)]")
            queue.run()
        } else {
            print("   └ [APPPUSH   CLOSE] ··················· [\(self.detail)]")
        }
    }
    
    public func open(_ application: Application?) -> BusinessQueue {
        if let application = application {
            if let queue = queues.value.included(application) {
                queue.state.accept(.active)
                return queue
            } else {
                let newQueue = BusinessQueue()
                _ = newQueue.state.on(type: .multiASync, { [weak self] state in
                    if state == .none {
                        print("   │    └ [QUEUE \(state.detail)] ┐··············· [\(newQueue.detail)]")
                        print("   │    │    ┌────────────┘")
                    } else {
                        print("   │    └ [QUEUE \(state.detail)] ················ [\(newQueue.detail)]")
                    }
                    
                    if let self = self {
                        switch state {
                        case .prepare:
                            self.queues.accept(self.queues.value.add(newQueue))
                            newQueue.state.accept(.ready)
                        case .ready:
                            newQueue.state.accept(.active)
                        case .active:
                            self.queues.accept(self.queues.value.sendToTop(newQueue))
                            self.run()
                        case .close:
                            self.queues.accept(self.queues.value.remove(newQueue))
                            if !newQueue.isSubQueue.value {
                                self.run()
                            }
                        default: break
                        }
                    }
                })
                
                store.accept(<#T##event: Store##Store#>)
                
                return newQueue.open(application, handle: {
                    newQueue.state.accept(.prepare)
                })
            }
        }
        
        return BusinessQueue()
    }
}

extension Array where Element: BusinessQueue {
    func included(_ app: Application) -> BusinessQueue? {
        return first(where: { $0.applications.value.first(where: { $0.id.value == app.id.value }) != nil })
    }
    
    func add(_ appQueue: BusinessQueue) -> [BusinessQueue] {
        return self + [appQueue]
    }
    
    func indexOf(_ appQueue: BusinessQueue) -> Int? {
        return firstIndex(where: { $0.id.value == appQueue.id.value })
    }
    
    func remove(_ appQueue: BusinessQueue) -> [BusinessQueue] {
        var temp = self
        if let index = indexOf(appQueue) {
            temp.remove(at: index)
        }
        return temp
    }
    
    func sendToTop(_ appQueue: BusinessQueue) -> [BusinessQueue] {
        var temp = self
        if let index = indexOf(appQueue) {
            if index != 0 {
                let queue = temp.remove(at: index)
                temp.insert(queue, at: 0)
            }
        }
        return temp
    }
}
