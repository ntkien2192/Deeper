//
//  HemeraStartViewController.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/31/19.
//

import UIKit
import RxCocoa
import RxSwift

class HemeraStartViewController: ViewController {
    
    @IBOutlet weak var imageView: ImageView!
    @IBOutlet weak var labelCopyrightInfo: Label!
    
    let viewModel = StartStore.share.viewModel.value
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        _ = viewModel.copyrightInfo.on { [weak self] copyrightInfo in
            if let copyrightInfo = copyrightInfo {
                self?.po(setup: copyrightInfo.detail)
                self?.labelCopyrightInfo.attributedText = copyrightInfo.attributedValue
            }
        }
        
        _ = wake().on(completed: { [weak self] in
            self?.imageView.dismiss(delay: 1)
            self?.labelCopyrightInfo.dismiss(delay: 1.3, handle: {
                print("   │    │    │    └ [CONTROLLER  CALL] ··· [Close] -> [\(self?.detail ?? "")]")
                self?.viewModel.activity.accept(.callClose)
            })
        })
    }
}
