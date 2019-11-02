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

public enum StatusBarStyle {
    case dark
    case light
}

public class ViewController: UIViewController {
    
    public var statusBarStyle = BehaviorRelay<StatusBarStyle>(value: .dark)
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return statusBarStyle.value == .dark ? UIStatusBarStyle.darkContent : UIStatusBarStyle.lightContent
        } else { return statusBarStyle.value == .dark ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        _ = Deeper.share.statusBarStyle.on { [weak self] _ in
            self?.refreshStatusBarStyle()
        }
        _ = self.view.rx.methodInvoked(#selector(UIView.layoutSubviews)).on({ _ in
            Deeper.share.statusBarStyle.accept(nil)
        })
    }
    
    func refreshStatusBarStyle() {
        calculateStatusBarAreaAvgLuminance { [weak self] avgLuminance in
            let antiFlick: CGFloat = 0.08 / 2
            if avgLuminance <= 0.6 - antiFlick {
                self?.statusBarStyle.accept(.light)
            } else if avgLuminance >= 0.6 + antiFlick {
                self?.statusBarStyle.accept(.dark)
            }
            
            UIView.animate(withDuration: 0.2) {
                self?.setNeedsStatusBarAppearanceUpdate()
            }
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
            print("   │    │    │    └ [CONTROLLER ENDED] ··· [\(self?.detail ?? "")]")
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
    

    
    func calculateStatusBarAreaAvgLuminance(_ completion: @escaping (CGFloat) -> Void) {
        let scale: CGFloat = 0.5
        let size = UIApplication.shared.statusBarFrame.size
        getLayer { layer in
            let queue = TaskQueue()
            queue.tasks +=! {
                UIGraphicsBeginImageContextWithOptions(size, false, scale)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                layer.render(in: context)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                guard let averageLuminance = image?.averageLuminance else { return }
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    completion(averageLuminance)
                }
            }
            queue.run()
        }
    }
    
    func getLayer(completion: @escaping (CALayer) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let layer = self?.parent?.view.layer else { return }
            completion(layer)
        }
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
    
    func dismiss(animated: Bool = true, handle: Handle = nil) {
        if let navigationController = self.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                handle?()
            }
            _ = navigationController.popViewController(animated: animated)
            CATransaction.commit()
        } else {
            self.dismiss(animated: animated, completion: {
                handle?()
            })
        }
    }
    
    func po(setup: String) {
        print("   │    │    │    └ [CONTROLLER SETUP] ┐·· [\(self.detail)]")
        print("   │    │    │    │    ┌───────────────┘")
        print("   │    │    │    │    └ [VALUE] ········· [\(setup)]")
    }
}
