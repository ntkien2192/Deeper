//
//  Database.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/8/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

enum StoreKey: String {
    case uuid = "48515769-24ab-460d-aa6d-7e80bf206536"
    
    var value: String {
        return self.rawValue
    }
}

class Database: NSObject {
    private struct store { static var instance: Database? }
    func clear() { Database.store.instance = nil }
    
    class var share: Database {
        if let data = store.instance { return data }
        let data = Database()
        store.instance = data
        return data
    }
    
    static let realm = try? Realm()
    let metadata = Metadata.getDataFromDB()
//    
//    let unit = BehaviorRelay<Unit>(value: Unit.getDataFromDB())
//    let tempUnit = BehaviorRelay<Unit>(value: Unit())
//
//    let user = BehaviorRelay<User>(value: User.getDataFromDB())
//    let tempUser = BehaviorRelay<User>(value: User())
}
