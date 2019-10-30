//
//  MetadataStore.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 9/2/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class MetadataStore: Object {
    
    private static let primaryKeyString = StoreKey.uuid.value + "MetadataStore"
    
    @objc dynamic var id = primaryKeyString
    @objc dynamic var theme = 0
//    @objc dynamic var isFirstTimeOpenWelcome = true
//    @objc dynamic var isFirstTimeOpenAskPermission = true
//    @objc dynamic var isFirstTimeToAuthorization = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func get() -> MetadataStore {
        if let realm = Database.realm, let store = realm.object(ofType: MetadataStore.self, forPrimaryKey: primaryKeyString) {
            return store
        }
        
        let store = MetadataStore()
        store.save(nil)
        return store
    }

    func set(theme: Theme = .deeper) {
        self.save { [weak self] in
            self?.theme = theme.value
        }
    }
    
//    func set(isFirstTimeAddUnit: Bool = true) {
//        self.save { [weak self] in
//            self?.isFirstTimeAddUnit = isFirstTimeAddUnit
//        }
//    }
//
//    func set(isFirstTimeOpenWelcome: Bool = true) {
//        self.save { [weak self] in
//            self?.isFirstTimeOpenWelcome = isFirstTimeOpenWelcome
//        }
//    }
//
//    func set(isFirstTimeOpenAskPermission: Bool = true) {
//        self.save { [weak self] in
//            self?.isFirstTimeOpenAskPermission = isFirstTimeOpenAskPermission
//        }
//    }
//
//    func set(isFirstTimeToAuthorization: Bool = true) {
//        self.save { [weak self] in
//            self?.isFirstTimeToAuthorization = isFirstTimeToAuthorization
//        }
//    }
    
    func save(_ handle: Handle) {
        if let realm = Database.realm {
            try? realm.write {
                if let handle = handle {
                    handle()
                } else {
                    realm.add(self)
                }
            }
        }
    }
}
