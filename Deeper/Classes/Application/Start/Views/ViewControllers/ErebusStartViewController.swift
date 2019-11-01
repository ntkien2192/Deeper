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
            self?.imageView.set(placeholder: image?.image.value)
            self?.imageView.set(image?.imageUrl.value)
            if let size = image?.size.value {
                self?.imageView.sizeThatFits(size)
            }
        })
        
        _ = wake().on(completed: { [weak self] in
            self?.imageView.setAnimation({
                self?.imageView.dismiss(delay: 0.2, handle: {
                    self?.viewModel.activity.accept(.callClose)
                })
            })
        })
    }
}
