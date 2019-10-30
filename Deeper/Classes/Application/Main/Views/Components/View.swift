//
//  View.swift
//  CailyNews
//
//  Created by Nguyễn Trung Kiên on 10/23/18.
//  Copyright © 2018 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum ViewState {
    case none
    case didMoveToSuperview
    case awakeFromNib
    case didMoveToWindow
}

class View: UIView {
    let id = BehaviorRelay<String>(value: UUID().uuidString)
    let key = BehaviorRelay<String>(value: "")
    let needFocus = BehaviorRelay<Bool>(value: true)
}

extension Array where Element: View {
    func add(_ view: View) -> [View] {
        return self + [view]
    }
}

extension Array where Element: UIControl {
    func enable(_ isEnable: Bool) {
        forEach { view in
            view.isEnabled = isEnable
        }
    }
}

var _viewStateData = [String: BehaviorRelay<ViewState>]()

extension UIView: WindowPresentation {
    
    var sizeAsObserver: Observable<CGSize> {
        return Observable.create({ observer -> Disposable in
            _ = self.rx.observe(CGRect.self, "bounds").on({ bounds in
                if let bounds = bounds {
                    observer.onNext(bounds.size)
                }
            })
            return Disposables.create()
        })
    }
    
    var state: BehaviorRelay<ViewState> {
        if let stateStore = _viewStateData[self.address] {
            return stateStore
        }
        let temp = BehaviorRelay<ViewState>(value: .none)
        
        _ = self.rx.sentMessage(#selector(didMoveToSuperview)).on({ _ in
            if self.superview != nil {
                print("   │    │    │    └ [VIEW START] ········· [\(self.detail)]")
            }
            temp.accept(.didMoveToSuperview)
        })
        _ = self.rx.sentMessage(#selector(awakeFromNib)).on({ _ in
            temp.accept(.awakeFromNib)
        })
        _ = self.rx.sentMessage(#selector(didMoveToWindow)).on({ _ in
            temp.accept(.didMoveToWindow)
        })
        _ = self.rx.sentMessage(#selector(removeFromSuperview)).on({ _ in
            print("   │    │    │    └ [VIEW CLOSE] ········· [\(self.detail)]")
        })
        
        _viewStateData[self.address] = temp
        return temp
    }
    
    func wake() -> Observable<Any?> {
        return Observable.create({ [weak self] observer -> Disposable in
            _ = self?.state.on({ state in
                if state == .didMoveToSuperview {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    @IBInspectable var shadow: Bool {
        get { return self.shadow }
        set {
            layer.masksToBounds = false
            layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2524207746)
            layer.shadowRadius = 8
            layer.shadowOpacity = 0.4
            layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map(UIColor.init) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue; layer.masksToBounds = newValue > 0 }
    }
    
    func add(_ view: UIView, fullSize: Bool = true, handle: Handle = nil) {
        view.alpha = 0
        
        var isCanAdd = true
        for subview in self.subviews {
            if view.address == subview.address {
                isCanAdd = false
            }
        }
        if isCanAdd {
            self.addSubview(view)
            if fullSize {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
            }
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 1
        })
        
        handle?()
    }
    
//    func add(atCenter view: UIView) {
//        self.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
//        self.addConstraint(xCenterConstraint)
//
//        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
//        self.addConstraint(yCenterConstraint)
//    }
    
//    func toController() -> UIViewController {
//        let view = UIViewController()
//        view.accessibilityFrame = size
//        view.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        view.view = self
//        return view
//    }
    
//    func change(_ constraint: NSLayoutConstraint?, value: CGFloat) {
//        if let constraint = constraint {
//            constraint.constant = value
//            setNeedsLayout()
//            UIView.animate(withDuration: 0.2) { [weak self] in
//                self?.layoutIfNeeded()
//            }
//        }
//    }
    
    func dismiss(delay: TimeInterval, duration: TimeInterval = 0.3, handle: Handle = nil) {
        let queue = TaskQueue()
        queue.tasks +=! { _, next in
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
                next(nil)
            }
        }
        queue.run {
            handle?()
        }
    }
    
//    class func getTargetView(_ view: UIView) -> [View] {
//        var circleArray = [View]()
//
//        for subview in view.subviews {
//            circleArray += getTargetView(subview)
//
//            if let subview = subview as? View {
//                circleArray.append(subview)
//            }
//        }
//
//        return circleArray
//    }
    
//    func addDash(_ dash: [NSNumber] = [8, 10], color: UIColor = #colorLiteral(red: 0.06274509804, green: 0.7333333333, blue: 0.5294117647, alpha: 1)) {
//        let layer = CAShapeLayer(layer: self.layer)
//        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 35)
//        layer.path = path.cgPath;
//        layer.strokeColor = color.cgColor
//        layer.lineDashPattern = dash
//        layer.lineWidth = 4
//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.fillColor = UIColor.clear.cgColor
//        self.layer.addSublayer(layer)
//    }
}

extension Array where Element: UIView {
    func dismiss(delay: TimeInterval = 0.0, duration: TimeInterval = 0.3, handle: Handle = nil) {
        let queue = TaskQueue()
        self.forEach({ view in
            queue.tasks +=! { _, next in
                view.dismiss(delay: delay, duration: duration, handle: {
                    next(nil)
                })
            }
        })
        queue.run {
            handle?()
        }
    }
}
