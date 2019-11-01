//
//  Label.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/31/19.
//

import UIKit
import RxSwift
import RxCocoa

class Label: SpringLabel {

}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.value
    }
    
    func accept(_ string: String, animation: Bool = false) {
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { [weak self] _ in
                self?.text = string
                UIView.animate(withDuration: 0.3, animations: {
                    self?.alpha = 1
                })
            }
        } else {
            text = string
        }
    }
}
