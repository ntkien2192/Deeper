//
//  StartViewModel.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 10/31/19.
//

import UIKit
import RxCocoa
import RxSwift

enum StartViewActivity {
    case none
    case callClose
}

public class StartViewModel: ViewModel {
    public let image = BehaviorRelay<Image?>(value: nil)
    public let copyrightInfo = BehaviorRelay<Content?>(value: nil)
    let activity = BehaviorRelay<StartViewActivity>(value: .none)

    public override init() {
        super.init()
        let image = Image(Image.assest.logo.value)
        self.image.accept(image)
        
        let copyrightInfo = Content("Power of Whale land", targets: ["Whale land"], displayType: .info)
        self.copyrightInfo.accept(copyrightInfo)
    }
    
    func response() -> Observable<StartViewActivity> {
        return Observable.create { [weak self] observer -> Disposable in
            _ = self?.activity.to(observer)
            return Disposables.create()
        }
    }
}
