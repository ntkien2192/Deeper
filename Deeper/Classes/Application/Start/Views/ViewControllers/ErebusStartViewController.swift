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

class ErebusStartViewController: ViewController {
    
    @IBOutlet weak var imageView: ImageView!
    
    let viewModel = StartStore.share.viewModel.value
    
    override func viewDidLoad() {
        _ = viewModel.image.on({ [weak self] image in
            if let image = image {
                self?.po(setup: image.detail)
                if let imageUrl = image.imageUrl.value {
                    self?.imageView.set(imageUrl)
                }
                if let image = image.image.value {
                    self?.imageView.set(placeholder: image)
                }
                if let size = image.size.value {
                    self?.imageView.constraints.get(NSLayoutConstraint.Attribute.height)?.constant = size.height
                    self?.imageView.constraints.get(NSLayoutConstraint.Attribute.width)?.constant = size.width
                }
            }
        })
        
        _ = wake().on(completed: { [weak self] in
            self?.imageView.dismissAnimation({
                self?.imageView.dismiss(delay: 1, handle: {
                    print("   │    │    │    └ [CONTROLLER  CALL] ··· [Close] -> [\(self?.detail ?? "")]")
                    self?.viewModel.activity.accept(.callClose)
                })
            })
        })
    }
}
