//
//  TextCardCollectionViewCell.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/3/19.
//

import UIKit

class TextCard1CollectionViewCell: CollectionViewCell {

    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelBody: UILabel!
    
    func bind(_ contentGroup: ContentGroup) {
        _ = contentGroup.title.on(type: .singleASync) { [weak self] title in
            self?.labelTitle.text = title?.rawValue
        }
        _ = contentGroup.subTitle.on(type: .singleASync) { [weak self] subTitle in
            self?.labelSubTitle.text = subTitle?.rawValue
        }
        _ = contentGroup.body.on(type: .singleASync) { [weak self] body in
            self?.labelBody.text = body?.rawValue
        }
    }

}
