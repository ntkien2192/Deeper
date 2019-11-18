//
//  ScrollView.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/13/19.
//

import UIKit
import RxCocoa
import RxSwift

class ScrollView: UIScrollView {

}

extension UIScrollView {
    func scrollEndX(_ x: CGFloat? = nil) {
        let end = contentSize.width - bounds.size.width + contentInset.right
        setContentOffset(CGPoint(x: x ?? end, y: 0), animated: false)
    }
    
    func onScroll(_ handle: @escaping (CGPoint) -> Void) {
        _ = rx.contentOffset.observeOn(MainScheduler.asyncInstance).bind(onNext: handle)
    }
}
