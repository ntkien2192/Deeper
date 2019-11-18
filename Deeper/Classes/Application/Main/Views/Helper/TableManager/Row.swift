//
//  Row.swift
//
//  Created by Nguyễn Trung Kiên on 10/22/18.
//  Copyright © 2018 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit

open class TableRow: Equatable {
    public static func == (lhs: TableRow, rhs: TableRow) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = NSObject()

    open var identifier: String?
    open var visible = true
    open var object: AnyObject?
    open var configuration: TableConfig?
    open var configurationWithIndex: TableConfigWithIndex?
    
    open var type: NSObject?
    
    weak var tableViewReference: UITableView?
    var indexPathReference: IndexPath?
    open weak var cell: UITableViewCell?
    
    public required init(identifier: String? = nil, visible: Bool = true, object: AnyObject? = nil) {
        self.identifier = identifier
        self.visible = visible
        self.object = object
    }
    
    @discardableResult
    open func config(_ block: @escaping TableConfig) -> TableRow {
        self.configuration = block
        return self
    }
    
    @discardableResult
    open func config(_ block: @escaping TableConfigWithIndex) -> TableRow {
        self.configurationWithIndex = block
        return self
    }
    
    public typealias TableConfig = (_ cell: UITableViewCell) -> Void
    public typealias TableConfigWithIndex = (_ cell: UITableViewCell, _ index: IndexPath) -> Void
}

open class CollectionRow: Equatable {
    public static func == (lhs: CollectionRow, rhs: CollectionRow) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = NSObject()
    
    open var identifier: String?
    open var visible = true
    open var object: AnyObject?
    
    open var configuration: CollectionConfig?
    
    weak var tableViewReference: UICollectionView?
    var indexPathReference: IndexPath?
    open weak var cell: UICollectionViewCell?
    
    public required init(identifier: String? = nil, visible: Bool = true, object: AnyObject? = nil) {
        self.identifier = identifier
        self.visible = visible
        self.object = object
    }
    
    @discardableResult
    open func config(_ block: @escaping CollectionConfig) -> CollectionRow {
        self.configuration = block
        return self
    }
    
    public typealias CollectionConfig = (_ cell: UICollectionViewCell) -> Void
}
