//
//  StartViewModel.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/31/19.
//

import UIKit
import RxCocoa
import RxSwift

public enum StartActivity {
    case none
    case callClose
}

public class StartViewModel: ViewModel {
    let image = BehaviorRelay<Image?>(value: nil)
    let copyrightInfo = BehaviorRelay<Content?>(value: nil)
    let activity = BehaviorRelay<StartActivity>(value: .none)
    
    public override init() {
        super.init()
        let image = Image(Image.assest.logo.value)
        self.image.accept(image)
        
        let copyrightInfo = Content("Power of Whale land", targets: ["Whale land"], displayType: .info)
        self.copyrightInfo.accept(copyrightInfo)
    }
    
    public func set(image: Image) {
        self.image.accept(image)
    }
    
    public func set(copyrightInfo: Content) {
        self.copyrightInfo.accept(copyrightInfo)
    }
}
