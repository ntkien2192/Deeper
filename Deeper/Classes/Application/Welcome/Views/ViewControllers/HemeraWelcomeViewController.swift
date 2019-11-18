//
//  HemeraWelcomeViewController.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/3/19.
//

import UIKit

class HemeraWelcomeViewController: ViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = WelcomeStore.share.viewModel.value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = collectionView.bounds.size.height
        collectionView.set(CGSize(width: height, height: height))
        
        _ = viewModel.introCards.on { introCards in
            introCards.forEach { [weak self] introCard in
                self?.collectionView.addRow(TextCard1CollectionViewCell.self, { cell in
                    cell.bind(introCard)
                })
                
                self?.collectionView.reloadData()
            }
        }
        
//        _ = viewModel.image.on({ [weak self] image in
//            if let image = image {
//                self?.po(setup: image.detail)
//                if let imageUrl = image.imageUrl.value {
//                    self?.imageView.set(imageUrl)
//                }
//                if let image = image.image.value {
//                    self?.imageView.set(placeholder: image)
//                }
//                if let size = image.size.value {
//                    self?.imageView.constraints.get(NSLayoutConstraint.Attribute.height)?.constant = size.height
//                    self?.imageView.constraints.get(NSLayoutConstraint.Attribute.width)?.constant = size.width
//                }
//            }
//        })
//
//        _ = viewModel.copyrightInfo.on { [weak self] copyrightInfo in
//            if let copyrightInfo = copyrightInfo {
//                self?.po(setup: copyrightInfo.detail)
//                self?.labelCopyrightInfo.attributedText = copyrightInfo.attributedValue
//            }
//        }
//
//        _ = wake().on(completed: { [weak self] in
//            self?.imageView.dismissAnimation({
//                self?.imageView.dismiss(delay: 0.1, handle: {
//                    print("   │    │    │    └ [CONTROLLER  CALL] ··· [Close] -> [\(self?.detail ?? "")]")
//                    self?.viewModel.activity.accept(.callClose)
//                })
//            })
//        })
    }
}
