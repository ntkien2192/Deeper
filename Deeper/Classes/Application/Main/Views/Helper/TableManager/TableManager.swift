//
//  TableManager.swift
//
//  Created by Nguyễn Trung Kiên on 10/22/18.
//  Copyright © 2018 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableManager: NSObject {
    
    static let id = "TableManagerCellIdentifier"
    
    weak var tableView: UITableView!
    
    var sections = [TableSection]()
    
    var sectionsToRender: [TableSection] {
        return sections.filter {
            $0.visible
        }
    }
    
    var scrollHandle: ((CGPoint) -> Void)?
    var animate = true
    
    required init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableManager.id)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func row(atIndexPath indexPath: IndexPath, includeAll: Bool = false) -> TableRow {
        let section = self.section(atIndex: indexPath.section, includeAll: includeAll)
        return section.row(atIndex: indexPath.row, includeAll: includeAll)
    }
    
    func section(atIndex index: Int, includeAll: Bool = false) -> TableSection {
        let objects = includeAll ? sections : sectionsToRender
        
        if objects.count > index {
            return objects[index]
        } else {
            return TableSection()
        }
    }
    
    func indexPath(forRow row: TableRow, includeAll: Bool = false) -> IndexPath? {
        let sectionObjects = includeAll ? sections : sectionsToRender
        
        var indexPath: IndexPath?
        
        sectionObjects.enumerated().forEach { indexSection, section in
            if let indexRow = section.index(forRow: row, includeAll: includeAll) {
                indexPath = IndexPath(row: indexRow, section: indexSection)
            }
        }
        
        return indexPath
    }
    
    func index(forSection section: TableSection, includeAll: Bool = false) -> Int? {
        let objects = includeAll ? sections : sectionsToRender
        
        return objects.firstIndex {
            $0 == section
        }
    }
    
    @discardableResult
    func addSection(_ section: TableSection? = nil) -> TableSection {
        let newSection = section ?? TableSection()
        if index(forSection: newSection, includeAll: true) == nil {
            sections.append(newSection)
        }
        return newSection
    }
    
    @discardableResult
    func addRow(_ row: TableRow? = nil) -> TableRow {
        let firstSection: TableSection
        if sections.count > 0 {
            firstSection = section(atIndex: 0)
        } else {
            firstSection = addSection()
        }
        
        return firstSection.addRow(row)
    }
    
    @discardableResult
    func addRow(_ identifier: String) -> TableRow {
        return addRow(TableRow(identifier: identifier))
    }
    
    @discardableResult
    func addRow<T>(_ type: T.Type, _ config: ((T) -> Void)?) -> TableRow {
        let row = TableRow(identifier: String(describing: type))
        row.config { (cell) in
            if let cell = cell as? T, let config = config {
                config(cell)
            }
        }
        
        return addRow(row)
    }
    @discardableResult
    func addRow<T>(_ type: T.Type, _ config: ((T, IndexPath) -> Void)?) -> TableRow {
        let row = TableRow(identifier: String(describing: type))
        row.config { (cell, index) in
            if let cell = cell as? T, let config = config {
                config(cell, index)
            }
        }
        
        return addRow(row)
    }
    
    func clearSections() {
        sections.removeAll()
    }
    
    func clearRows() {
        if sections.count > 0 {
            sections[0].clearRows()
        }
    }
    
    func convertToIncludeAllIndexPath(withToRenderIndexPath indexPath: IndexPath) -> IndexPath? {
        let row = self.row(atIndexPath: indexPath)
        return self.indexPath(forRow: row, includeAll: true)
    }
}

extension TableManager: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToRender.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section(atIndex: section).rowsToRender.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.row(atIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: row.identifier ?? TableManager.id, for: indexPath)
        
        row.cell = cell
        row.configuration?(cell)
        row.configurationWithIndex?(cell, indexPath)
        row.indexPathReference = indexPath
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell.tag == 0 {
//            return
//        }
//        cell.alpha = 0
//        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//        UIView.animate(withDuration: 0.4) {
//            cell.alpha = 1
//            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollHandle = scrollHandle {
            scrollHandle(scrollView.contentOffset)
        }
    }
}

import UIKit

class CollectionManager: NSObject {
    
    static let id = "CollectionManagerCellIdentifier"
    
    weak var collectionView: UICollectionView!
    
    var sections = [CollectionSection]()
    
    var sectionsToRender: [CollectionSection] {
        return sections.filter {
            $0.visible
        }
    }
    
    var size = CGSize(width: 44, height: 44)
    
    required init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionManager.id)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func row(atIndexPath indexPath: IndexPath, includeAll: Bool = false) -> CollectionRow {
        let section = self.section(atIndex: indexPath.section, includeAll: includeAll)
        return section.row(atIndex: indexPath.row, includeAll: includeAll)
    }
    
    func section(atIndex index: Int, includeAll: Bool = false) -> CollectionSection {
        let objects = includeAll ? sections : sectionsToRender
        
        if objects.count > index {
            return objects[index]
        } else {
            return CollectionSection()
        }
    }
    
    func indexPath(forRow row: CollectionRow, includeAll: Bool = false) -> IndexPath? {
        let sectionObjects = includeAll ? sections : sectionsToRender
        
        var indexPath: IndexPath?
        
        sectionObjects.enumerated().forEach { indexSection, section in
            if let indexRow = section.index(forRow: row, includeAll: includeAll) {
                indexPath = IndexPath(row: indexRow, section: indexSection)
            }
        }
        
        return indexPath
    }
    
    func index(forSection section: CollectionSection, includeAll: Bool = false) -> Int? {
        let objects = includeAll ? sections : sectionsToRender
        
        return objects.firstIndex {
            $0 == section
        }
    }
    
    @discardableResult
    func addSection(_ section: CollectionSection? = nil) -> CollectionSection {
        let newSection = section ?? CollectionSection()
        if index(forSection: newSection, includeAll: true) == nil {
            sections.append(newSection)
        }
        return newSection
    }
    
    @discardableResult
    func addRow(_ row: CollectionRow? = nil) -> CollectionRow {
        let firstSection: CollectionSection
        if sections.count > 0 {
            firstSection = section(atIndex: 0)
        } else {
            firstSection = addSection()
        }
        
        return firstSection.addRow(row)
    }
    
    @discardableResult
    func addRow(_ identifier: String) -> CollectionRow {
        return addRow(CollectionRow(identifier: identifier))
    }
    
    @discardableResult
    func addRow<T>(_ type: T.Type, _ config: ((T) -> Void)?) -> CollectionRow {
        let row = CollectionRow(identifier: String(describing: type))
        row.config { (cell)  in
            if let cell = cell as? T, let config = config {
                config(cell)
            }
        }
        
        return addRow(row)
    }
    
    func set(_ size: CGSize) {
        self.size = size
    }
    
    func clearSections() {
        sections.removeAll()
    }
    
    func clearRows() {
        if sections.count > 0 {
            sections[0].clearRows()
        }
    }
    
    func convertToIncludeAllIndexPath(withToRenderIndexPath indexPath: IndexPath) -> IndexPath? {
        let row = self.row(atIndexPath: indexPath)
        return self.indexPath(forRow: row, includeAll: true)
    }
}

extension CollectionManager: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsToRender.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section(atIndex: section).rowsToRender.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.row(atIndexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.identifier ?? CollectionManager.id, for: indexPath)
        
        row.cell = cell
        row.configuration?(cell)
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.size
    }
}
