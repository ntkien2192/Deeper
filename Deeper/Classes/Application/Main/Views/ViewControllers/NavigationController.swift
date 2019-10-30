//
//  NavigationBar.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 7/2/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NavigationController: UINavigationController {
    
    let isShowTitle = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .default
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
        
        navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always
        
//        _ = isShowTitle.on(type: .singleASync, { isShowTitle in
//            self.navigationBar.titleTextAttributes = [
//                NSAttributedString.Key.font : UIFont(name: fontBold, size: 14) as Any
//            ]
//        })
    }
}

extension UIViewController {
    func onNavigation(_ hideNavigationBar: Bool = false) -> NavigationController {
        let view = NavigationController(rootViewController: self)
        view.isNavigationBarHidden = hideNavigationBar
        return view
    }
}
