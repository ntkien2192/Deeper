//
//  Section.swift
//
//  Created by Nguyễn Trung Kiên on 10/22/18.
//  Copyright © 2018 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit

open class TableSection: Equatable {
    public static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = NSObject()
    
    open var visible = true
    open var object: AnyObject?
    
    open var rows = [TableRow]()
    
    open var rowsToRender: [TableRow] {
        return rows.filter {
            $0.visible
        }
    }
    
    public required init(visible: Bool = true, object: AnyObject? = nil) {
        self.visible = visible
        self.object = object
    }
    
    open func row(atIndex index: Int, includeAll: Bool = false) -> TableRow {
        let objects = includeAll ? rows : rowsToRender
        
        if objects.count > index {
            return objects[index]
        } else {
            return TableRow()
        }
    }
    
    /// Returns the index of the Row if exist
    open func index(forRow row: TableRow, includeAll: Bool = false) -> Int? {
        let objects = includeAll ? rows : rowsToRender
        
        return objects.firstIndex {
            $0 == row
        }
    }
    
//    public func addSpace(_ height: CGFloat = 0) {
//        addRow(SpaceTableViewCell.self, { cell in
//            cell.bind(height)
//        })
//    }
    
    @discardableResult
    open func addRow(_ row: TableRow? = nil) -> TableRow {
        let newRow = row ?? TableRow()
        if index(forRow: newRow, includeAll: true) == nil {
            rows.append(newRow)
        }
        return newRow
    }
    
    @discardableResult
    open func addRow(_ identifier: String) -> TableRow {
        return addRow(TableRow(identifier: identifier))
    }
    
    @discardableResult
    open func addRow<T>(_ type: T.Type) -> TableRow {
        return addRow(TableRow(identifier: String(describing: type)))
    }
    
    @discardableResult
    open func addRow<T>(_ type: T.Type, _ config: ((T) -> Void)?) -> TableRow {
        let row = TableRow(identifier: String(describing: type))
        row.config { (cell) in
            if let cell = cell as? T, let config = config {
                config(cell)
            }
        }
        
        return addRow(row)
    }

    @discardableResult
    open func addRow<T>(_ type: T.Type, _ config: ((T, IndexPath) -> Void)?) -> TableRow {
        let row = TableRow(identifier: String(describing: type))
        row.config { (cell, index) in
            if let cell = cell as? T, let config = config {
                config(cell, index)
            }
        }
        
        return addRow(row)
    }
    
    @discardableResult
    open func clearRows() -> TableSection {
        rows.removeAll()
        return self
    }
}

//extension TableSection {
//    func addInfo(_ control: Control, top: CGFloat? = nil, bottom: CGFloat? = nil) {
//        if let top = top {
//            self.addSpace(top)
//        }
//        self.addRow(InfoTableViewCell.self) { cell in
//            cell.bind(control.content.value)
//            cell.buttonCell.on({
//                control.handle?()
//            })
//        }
//        if let bottom = bottom {
//            self.addSpace(bottom)
//        }
//    }
//    
//    func addSubTitle(_ control: Control, top: CGFloat? = nil, bottom: CGFloat? = nil) {
//        if let top = top {
//            self.addSpace(top)
//        }
//        self.addRow(SubTitleTableViewCell.self) { cell in
//            cell.bind(control.content.value)
//            cell.buttonCell.on {
//                control.handle?()
//            }
//        }
//        if let bottom = bottom {
//            self.addSpace(bottom)
//        }
//    }
//}

open class CollectionSection: Equatable {
    public static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = NSObject()
    
    open var visible = true
    
    open var object: AnyObject?
    
    open var rows = [CollectionRow]()
    
    open var rowsToRender: [CollectionRow] {
        return rows.filter {
            $0.visible
        }
    }
    
    public required init(visible: Bool = true, object: AnyObject? = nil) {
        self.visible = visible
        self.object = object
    }
    
    open func row(atIndex index: Int, includeAll: Bool = false) -> CollectionRow {
        let objects = includeAll ? rows : rowsToRender
        
        if objects.count > index {
            return objects[index]
        } else {
            return CollectionRow()
        }
    }
    
    /// Returns the index of the Row if exist
    open func index(forRow row: CollectionRow, includeAll: Bool = false) -> Int? {
        let objects = includeAll ? rows : rowsToRender
        
        return objects.firstIndex {
            $0 == row
        }
    }
    
    @discardableResult
    open func addRow(_ row: CollectionRow? = nil) -> CollectionRow {
        let newRow = row ?? CollectionRow()
        if index(forRow: newRow, includeAll: true) == nil {
            rows.append(newRow)
        }
        return newRow
    }
    
    @discardableResult
    open func addRow(_ identifier: String) -> CollectionRow {
        return addRow(CollectionRow(identifier: identifier))
    }
    
    @discardableResult
    open func clearRows() -> CollectionSection {
        rows.removeAll()
        return self
    }
}
