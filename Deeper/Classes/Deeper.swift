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
    let store = Store()
    
    override init() {
        super.init()
        print("   ┌──────────────┘")
        print("   └ [APPPUSH PREPARE] ┐·················· [\(self.detail)]")
        print("   │    ┌──────────────┘")
    }
    
    let queues = BehaviorRelay<[BusinessQueue]>(value: [])
    
    public class func on(_ window: UIWindow?, theme: Theme = .deeper, handle: Handle) {
        
        Deeper.share.store.database.metadata.theme.accept(theme)
        Deeper.share.store.database.metadata.saveToDB()
        
        print("[FUTUREP PREPARE] ┐")
        if let view = window?.rootViewController {
            _ = view.waked().on(completed: {
                print("   └──────────────┘\n")
                print("[FUTUREP   START] ┐")
                handle?()
            })
        }
    }
    
    public class func open(_ application: Application?) -> BusinessQueue {
        if let application = application {
            let appPush = Deeper.share
            if let queue = appPush.queues.value.included(application) {
                queue.state.accept(.active)
                return queue
            } else {
                let newQueue = BusinessQueue()
                _ = newQueue.state.on(type: .multiASync, { state in
                    if state == .none {
                        print("   │    └ [QUEUE \(state.detail)] ┐··············· [\(newQueue.detail)]")
                        print("   │    │    ┌────────────┘")
                    } else {
                        print("   │    └ [QUEUE \(state.detail)] ················ [\(newQueue.detail)]")
                    }
                    
                    switch state {
                    case .prepare:
                        appPush.queues.accept(appPush.queues.value.add(newQueue))
                        newQueue.state.accept(.ready)
                    case .ready:
                        newQueue.state.accept(.active)
                    case .active:
                        appPush.queues.accept(appPush.queues.value.sendToTop(newQueue))
                        appPush.run()
                    case .close:
                        appPush.queues.accept(appPush.queues.value.remove(newQueue))
                        if !newQueue.isSubQueue.value {
                            appPush.run()
                        }
                    default: break
                    }
                })
                return newQueue.then(application, handle: {
                    newQueue.state.accept(.prepare)
                })
            }
        }
        
        return BusinessQueue()
    }
    
    func run() {
        if let queue = queues.value.first {
            print("   └ [APPPUSH   START] ··················· [\(self.detail)]")
            queue.run()
        } else {
            print("   └ [APPPUSH   CLOSE] ··················· [\(self.detail)]")
        }
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
