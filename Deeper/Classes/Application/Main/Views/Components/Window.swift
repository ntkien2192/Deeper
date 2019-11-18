//
//  Window.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/13/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit

typealias WindowPriority = Float

extension WindowPriority {
    static var Low: WindowPriority = 250
    static var Required: WindowPriority = 500
    static var High: WindowPriority = 750
}

enum WindowStatus {
    case presented
    case waitingInStack
    case none
}

public class Window {
    public static var share: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level(windowLevel)
        window.isHidden = true
        return window
    }()
    
    static var stack: [WindowPresentation] = []
    
    static var windowLevel: CGFloat {
        return UIWindow.Level.alert.rawValue - 1
    }
    
    fileprivate static func dropRootViewController() {
        share.isHidden = true
        share.rootViewController = nil
    }
}

protocol WindowStack {
    var canDismiss: Bool { get }
    var priority: WindowPriority { get }
}

protocol WindowPresentation: class, WindowStack {
    func presenterPresent(animated: Bool, handle: Handle)
    func presenterDismiss(animated: Bool, handle: Handle)
}

extension WindowPresentation {
    var modalStatus: WindowStatus {
        if Window.share.rootViewController === self { return .presented }
        if Window.stack.contains(where: { $0 === self }) { return .waitingInStack }
        return .none
    }
    
    var stack: [WindowPresentation] { return Window.stack }
    var canDismiss: Bool { return false }
    var priority: WindowPriority { return .Required }
}

extension WindowPresentation where Self: UIViewController {
    
    func sReplace<T: UIViewController>(with controller: T, animated: Bool = false, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if animated {
                Window.share.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    Window.share.rootViewController = controller
                    Window.share.alpha = 1
                }, completion: { completed in
                    Window.share.makeKey()
                    completion?()
                })
            } else {
                Window.share.rootViewController = controller
                Window.share.alpha = 1
                Window.share.isHidden = false
                Window.share.makeKey()
                completion?()
            }
        }
    }
    
    func presenterPresent(animated: Bool = true, handle: Handle = nil) {
        func presentController() {
            guard let currentPresented = UIViewController.topController(Window.share.rootViewController) else {
                completedProcedure()
                return
            }
            
            Window.stack.append(self)
            if currentPresented.canDismiss == true {
                currentPresented.presenterDismiss(animated: animated, handle: handle)
            } else {
                self.modalPresentationStyle = .fullScreen
                currentPresented.present(self, animated: animated) { handle?() }
            }
        }
        
        func completedProcedure() {
            Window.share.makeKey() 
            Window.share.alpha = 1
            Window.share.isHidden = false

            if animated {
                var options = UIWindow.TransitionOptions()
                options.direction = .toTop
                options.duration = 0.3
                options.background = .snapshot
                options.style = .easeOut
                Window.share.setRootViewController(self, options: options)
                DispatchQueue.main.asyncAfter(deadline: .now() + options.duration, execute: { handle?() })
            } else {
                Window.share.rootViewController = self
                Window.share.makeKeyAndVisible()
                handle?()
            }
        }
        
        let queue = TaskQueue()
        queue.tasks +=! {
            presentController()
        }
        queue.run()
    }
    
    func presenterDismiss(animated: Bool = false, handle: Handle = nil) {
        func dismissController() {
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
        
        func prepareTodismissController() {
            if Window.share.rootViewController === self {
                if animated {
                    Window.share.alpha = 1
                    UIView.animate(withDuration: 0.3, animations: {
                        Window.share.alpha = 0
                    }, completion: { completed in
                        Window.dropRootViewController()
                        completedProcedure()
                    })
                } else {
                    Window.share.alpha = 0
                    Window.dropRootViewController()
                    completedProcedure()
                }
            } else if Window.stack.contains(where: { $0 === self }) {
                dismissController()
                Window.stack = Window.stack.filter() { !($0 === self) }
            } else {
                dismissController()
            }
        }
        
        func completedProcedure() {
            if let controller = Window.stack.sorted(by: {$0.priority > $1.priority}).first {
                Window.stack = Window.stack.filter({ $0 !== controller })
                controller.presenterPresent(animated: animated, handle: handle)
            } else {
                handle?()
            }
        }
        
        let queue = TaskQueue()
        queue.tasks +=! {
            prepareTodismissController()
        }
        queue.run()
    }
}

extension WindowPresentation where Self: UIView {
    func presenterPresent(animated: Bool = true, handle: Handle = nil) {
        let queue = TaskQueue()
        queue.tasks +=! { [weak self] in
            if let self = self {
                guard let currentPresented = Window.share.rootViewController else {
                    return
                }
                guard let view = UIViewController.topController(currentPresented) else {
                    currentPresented.view.add(self, handle: handle)
                    return
                }
                view.view.add(self, handle: handle)
            }
        }
        queue.run()

    }
    
    func presenterDismiss(animated: Bool = false, handle: Handle = nil) {
        let queue = TaskQueue()
        queue.tasks +=! { [weak self] in
            if let self = self {
                self.dismiss(delay: 0.0, handle: handle)
            }
        }
        queue.run()
    }
}

extension UIWindow {
    struct TransitionOptions {
        enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut
            
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear: key = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.linear)
                case .easeIn: key = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.easeIn)
                case .easeOut: key = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.easeOut)
                case .easeInOut: key = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.easeInEaseOut)
                }
                return CAMediaTimingFunction(name: convertToCAMediaTimingFunctionName(key))
            }
        }
        
        enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight
            
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade: transition.type = CATransitionType.fade; transition.subtype = nil
                case .toLeft: transition.subtype = CATransitionSubtype.fromLeft
                case .toRight: transition.subtype = CATransitionSubtype.fromRight
                case .toTop: transition.subtype = CATransitionSubtype.fromTop
                case .toBottom: transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }
        
        enum Background {
            case snapshot
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }
        
        var duration: TimeInterval = 0.20
        var direction: TransitionOptions.Direction = .toRight
        var style: TransitionOptions.Curve = .linear
        var background: TransitionOptions.Background? = nil
        
        init() {}
        
        init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }
        
        internal var animation: CATransition {
            let transition = self.direction.transition()
            transition.duration = self.duration
            transition.timingFunction = self.style.function
            return transition
        }
    }
    
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {
        
        var transitionWnd: UIWindow? = nil
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
                  switch background {
                  case .snapshot:
                    if let currentView = snapshotView(afterScreenUpdates: true) {
                      transitionWnd?.rootViewController = UIViewController.newController(withView: currentView, frame: transitionWnd!.bounds)
                    }
                  case .customView(let view):
                      transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
                  case .solidColor(let color):
                      transitionWnd?.backgroundColor = color
                  }
                  transitionWnd?.makeKeyAndVisible()
              }
        
        self.layer.add(options.animation, forKey: kCATransition)
        self.rootViewController = controller
        self.makeKeyAndVisible()
        
        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: (.now() + 1 + options.duration), execute: {
                wnd.removeFromSuperview()
            })
        }
    }
}
 
extension UIViewController {
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
}

func convertFromCAMediaTimingFunctionName(_ input: CAMediaTimingFunctionName) -> String {
    return input.rawValue
}

func convertToCAMediaTimingFunctionName(_ input: String) -> CAMediaTimingFunctionName {
    return CAMediaTimingFunctionName(rawValue: input)
}
