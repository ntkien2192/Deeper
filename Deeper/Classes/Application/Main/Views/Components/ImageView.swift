//
//  ImageView.swift
//  Whale-Wallpapers
//
//  Created by Nguyễn Trung Kiên on 11/5/18.
//  Copyright © 2018 Whale Land. All rights reserved.
//

import UIKit
import SDWebImage

class ImageView: SpringImageView {
    
}

extension UIImageView {

    func set(_ image: UIImage?, with color: UIColor) {
        let newImage = image?.withRenderingMode(.alwaysTemplate)
        self.image = newImage
        self.tintColor = color
    }
    
    func set(_ urlString: String? = nil, placeholder: UIImage? = nil) {
        if let urlString = urlString, let url = URL(string: urlString) {
            let queue = TaskQueue()
            queue.tasks +=~ { [weak self] in
                self?.sd_setImage(with: url, placeholderImage: placeholder)
            }
            queue.run()
        } else {
            self.image = placeholder
        }
    }
}
