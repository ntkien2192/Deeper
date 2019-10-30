//
//  Metadata.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/8/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Metadata: NSObject {
    let theme = BehaviorRelay<Theme>(value: .deeper)
//    let isFirstTimeAddUnit = BehaviorRelay<Bool>(value: true)
//    let isFirstTimeOpenWelcome = BehaviorRelay<Bool>(value: true)
//    let isFirstTimeOpenAskPermission = BehaviorRelay<Bool>(value: true)
//    let isFirstTimeToAuthorization = BehaviorRelay<Bool>(value: true)
    
    let store = MetadataStore.get()
    
    class func getDataFromDB() -> Metadata {
        let metaData = Metadata()
        metaData.theme.accept(Theme(metaData.store.theme))
        
//        metaData.isFirstTimeAddUnit.accept(metaData.store.isFirstTimeAddUnit)
//        metaData.isFirstTimeOpenWelcome.accept(metaData.store.isFirstTimeOpenWelcome)
//        metaData.isFirstTimeOpenAskPermission.accept(metaData.store.isFirstTimeOpenAskPermission)
//        metaData.isFirstTimeToAuthorization.accept(metaData.store.isFirstTimeToAuthorization)
        return metaData
    }
    
    func saveToDB() {
//        self.store.set(isFirstTimeAddUnit: isFirstTimeAddUnit.value)
//        self.store.set(isFirstTimeOpenWelcome: isFirstTimeOpenWelcome.value)
//        self.store.set(isFirstTimeOpenAskPermission: isFirstTimeOpenAskPermission.value)
//        self.store.set(isFirstTimeToAuthorization: isFirstTimeToAuthorization.value)
    }
}
