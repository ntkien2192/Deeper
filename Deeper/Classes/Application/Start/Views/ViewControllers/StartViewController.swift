//
//  StartViewController.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/6/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum StartViewControllerActivity {
    case none
    case callClose
}

class StartViewController: ViewController {
    @IBOutlet weak var imageView: ImageView!
//    
//    func bind() -> Observable<StartViewControllerActivity> {
//        return Observable.create { [weak self] observer -> Disposable in
//            _ = self?.wake().on(completed: {
//                if let imageView = self?.imageView {
//                    imageView.setAnimation({
//                        imageView.dismiss(delay: 0.2, handle: {
//                            observer.onNext(.callClose)
//                        })
//                    })
//                }
//            })
//            return Disposables.create()
//        }
//    }
}
