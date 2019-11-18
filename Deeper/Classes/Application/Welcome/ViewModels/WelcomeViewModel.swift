//
//  WelcomeViewModel.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/3/19.
//

import UIKit
import RxCocoa
import RxSwift

enum WelcomeViewActivity {
    case none
    case callClose
}

public class WelcomeViewModel: ViewModel {
    public let image = BehaviorRelay<Image?>(value: nil)
    public let introCards = BehaviorRelay<[ContentGroup]>(value: [])
    let activity = BehaviorRelay<WelcomeViewActivity>(value: .none)

    public override init() {
        super.init()
        let image = Image(Image.assest.welcomeBackground.value)
        self.image.accept(image)
        
        let subTitle1 = Content("More than")
        let title1 = Content("Comfort")
        let body1 = Content("Let deeper help you manage everything in the house with the easiest and most comfortable way.")
        let contenGroup1 = ContentGroup(title: title1, subTitle: subTitle1, body: body1)
        
        self.introCards.accept([contenGroup1, contenGroup1, contenGroup1])
    }
    
    func response() -> Observable<WelcomeViewActivity> {
        return Observable.create { [weak self] observer -> Disposable in
            _ = self?.activity.to(observer)
            return Disposables.create()
        }
    }
}
