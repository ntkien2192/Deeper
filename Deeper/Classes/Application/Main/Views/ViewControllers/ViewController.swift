//
//  ViewController.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 5/7/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum ViewControllerState {
    case none
    case viewDidLoad
    case viewWillAppear
    case viewDidWaked
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
}

public class ViewController: UIViewController {
    
    @IBInspectable var navigationImage: UIImage?
    
    let isHideNavigationBar = BehaviorRelay<Bool>(value: false)
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationImage = self.navigationImage, let navigationController = self.navigationController {
//            navigationController.setNavigation(navigationImage)
            
        }
    }
    
    
}

var _viewControllerStateData = [String: BehaviorRelay<ViewControllerState>]()
var _viewControllerWakeData = [String: Bool]()

extension UIViewController: WindowPresentation {
    
    var stateStore: BehaviorRelay<ViewControllerState>? {
        get { return _viewControllerStateData[self.address] }
        set(newValue) { _viewControllerStateData[self.address] = newValue }
    }

    var isWaked: Bool {
        get { return _viewControllerWakeData[self.address] ?? false }
        set(newValue) { _viewControllerWakeData[self.address] = newValue }
    }
    
    var state: BehaviorRelay<ViewControllerState> {
        if let stateStore = stateStore {
            return stateStore
        }
        let temp = BehaviorRelay<ViewControllerState>(value: .none)
        
        _ = self.rx.sentMessage(#selector(viewDidLoad)).on({ [weak self] _ in
            print("   │    │    │    └ [CONTROLLER START] ··· [\(self?.detail ?? "")]")
            temp.accept(.viewDidLoad)
        })
        _ = self.rx.sentMessage(#selector(viewWillAppear(_:))).on({ [weak self] _ in
            print("   │    │    │    └ [CONTROLLER  SHOW] ··· [\(self?.detail ?? "")]")
            temp.accept(.viewWillAppear)
        })
        _ = self.rx.sentMessage(#selector(viewDidAppear(_:))).on({ [weak self] _ in
            if !(self?.isWaked ?? false) {
                self?.isWaked = true
                temp.accept(.viewDidWaked)
            }
            temp.accept(.viewDidAppear)
        })
        _ = self.rx.sentMessage(#selector(viewWillDisappear(_:))).on({  _ in
            temp.accept(.viewWillDisappear)
        })
        _ = self.rx.sentMessage(#selector(viewDidDisappear(_:))).on({ [weak self] _ in
            print("   │    │    │    └ [CONTROLLER  HIDE] ··· [\(self?.detail ?? "")]")
            temp.accept(.viewDidDisappear)
        })
        
        stateStore = temp
        return temp
    }
    
    func wake() -> Observable<Any?> {
        return Observable.create({ [weak self] observer -> Disposable in
            _ = self?.state.on({ state in
                if state == .viewDidLoad {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    func waked() -> Observable<Any?> {
        return Observable.create({ [weak self] observer -> Disposable in
            _ = self?.state.on({ state in
                if state == .viewDidWaked {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }

    func closed() -> Observable<Any?> {
        return Observable.create({ [weak self] observer -> Disposable in
            _ = self?.state.on({ state in
                if state == .viewDidDisappear {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    class func topController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topController(presented)
        }
        return base
    }
    
    func add(_ viewController: UIViewController) {
        if let navigationController = self.navigationController {
            navigationController.show(viewController, sender: nil)
        } else {
            if let topController = UIViewController.topController() {
                if let navigationController = topController.navigationController {
                    navigationController.show(viewController, sender: nil)
                } else {
                    let navigationController = NavigationController(rootViewController: viewController)
                    topController.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func dismiss(_ handle: Handle = nil) {
        if let navigationController = self.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                handle?()
            }
            _ = navigationController.popViewController(animated: true)
            CATransaction.commit()
        } else {
            self.dismiss(animated: true, completion: {
                handle?()
            })
        }
    }
}


