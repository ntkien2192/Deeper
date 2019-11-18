//
//  CollectionViewCell.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/3/19.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionViewCell: UICollectionViewCell {
    let size = BehaviorRelay<CGSize>(value: CGSize(width: 44, height: 44))
}
