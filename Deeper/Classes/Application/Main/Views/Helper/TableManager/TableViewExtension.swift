//
//  TableViewExtension.swift
//
//  Created by Nguyễn Trung Kiên on 10/22/18.
//  Copyright © 2018 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
//import MXParallaxHeader

internal let instanceTableKey = "tableManagerInstance"
internal let instanceCollectionKey = "collectionManagerInstance"

extension UITableView {
    static let headerHeight: CGFloat = 130
    
    var contentHeight: CGFloat {
        self.layoutIfNeeded()
        return self.contentSize.height
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        tableFooterView = UIView()
        register()
    }
    
    func register() {
//        register(SpaceTableViewCell.self)
//        register(SubTitleTableViewCell.self)
//        register(InfoTableViewCell.self)
//        register(TitleTableViewCell.self)
    }
    
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

//    func addTitle(_ control: Control, top: CGFloat? = nil, bottom: CGFloat? = nil) {
//        if let top = top {
//            self.addSpace(top)
//        }
//        self.addRow(TitleTableViewCell.self) { cell in
//            cell.bind(control.content.value)
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

//    func setViewTitle(_ content: Content) {
//        let view = HeaderView(content)
//        setHeader(view, height: UITableView.headerHeight)
//
//
//    }
//
//    func setHeader(_ view: UIView, height: CGFloat, minHeight: CGFloat = 0) {
//        self.parallaxHeader.view = view
//        self.parallaxHeader.height = height
//        self.parallaxHeader.mode = MXParallaxHeaderMode.fill
//        self.parallaxHeader.minimumHeight = minHeight
//    }
    
    func refresh(_ handle: @escaping () -> Void) {
        let refreshControl = UIRefreshControl()
        _ = refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { _ in
            refreshControl.endRefreshing()
            handle()
        })
        self.refreshControl = refreshControl
        self.bringSubviewToFront(self.refreshControl ?? refreshControl)
    }
}

extension UITableView {
    func register<T>(_ type: T.Type) {
        self.register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
    
    func layoutCell() {
        beginUpdates()
        endUpdates()
    }
    
    func tableManagerInstance() -> TableManager {
        guard let tableManager = self.layer.value(forKey: instanceTableKey) as? TableManager else {
            let tableManager = TableManager(tableView: self)
            self.layer.setValue(tableManager, forKey: instanceTableKey)
            return tableManager
        }
        return tableManager
    }
    
    var sections: [TableSection] {
        set {
            self.tableManagerInstance().sections = newValue
        }
        get {
            return self.tableManagerInstance().sections
        }
    }
    
    func reload(section: TableSection) {
        if let index = self.tableManagerInstance().index(forSection: section) {
            self.tableManagerInstance().tableView.reloadSections([index], with: UITableView.RowAnimation.fade)
        }
    }
    
    func scroll(_ scrollHandle: ((CGPoint) -> Void)?) {
        self.tableManagerInstance().scrollHandle = scrollHandle
    }
    
    var sectionsToRender: [TableSection] {
        return self.tableManagerInstance().sectionsToRender
    }
    
    func row(atIndexPath indexPath: IndexPath, includeAll: Bool = false) -> TableRow {
        return self.tableManagerInstance().row(atIndexPath: indexPath)
    }
    
    func section(atIndex index: Int, includeAll: Bool = false) -> TableSection {
        return self.tableManagerInstance().section(atIndex: index)
    }
    
    func indexPath(forRow row: TableRow, includeAll: Bool = false) -> IndexPath? {
        return self.tableManagerInstance().indexPath(forRow: row, includeAll: includeAll) as IndexPath?
    }
    
    func index(forSection section: TableSection, includeAll: Bool = false) -> Int? {
        return self.tableManagerInstance().index(forSection: section, includeAll: includeAll)
    }
    
//    @discardableResult
//    public func addSpace(_ height: CGFloat = 0) -> TableRow {
//        return self.tableManagerInstance().addRow(SpaceTableViewCell.self, { cell in
//            cell.bind(height)
//        })
//    }
    
    @discardableResult
    func addSection(_ section: TableSection? = nil) -> TableSection {
        return self.tableManagerInstance().addSection(section)
    }
    
    @discardableResult
    func addRow(_ row: TableRow? = nil) -> TableRow {
        return self.tableManagerInstance().addRow(row)
    }
    
    @discardableResult
    func addRow(_ identifier: String) -> TableRow {
        return self.tableManagerInstance().addRow(identifier)
    }
    
    @discardableResult
    func addRow<T>(_ type: T.Type, _ config: ((T) -> Void)? = nil) -> TableRow {
        return self.tableManagerInstance().addRow(type, config)
    }
    
    @discardableResult
    func addRow<T>(_ type: T.Type, _ config: ((T, IndexPath) -> Void)?) -> TableRow {
        return self.tableManagerInstance().addRow(type, config)
    }
    
    func clearSections() {
        self.tableManagerInstance().clearSections()
    }
    
    func clearRows() {
        self.tableManagerInstance().clearRows()
    }
    
    func reloadData(_ handle: Handle) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            handle?()
        })
        reloadData()
        CATransaction.commit()
    }
}

// collection

var _collectionViewRegisterData = [String: Bool]()

extension UICollectionView {
    func register<T>(_ type: T.Type) -> Bool {
        guard let bundle = Bundle.deeperBundle else {
            return false
        }
        self.register(UINib(nibName: String(describing: type), bundle: bundle), forCellWithReuseIdentifier: String(describing: type))
        return true
    }
    
    func collectionManagerInstance() -> CollectionManager {
        guard let collectionManager = self.layer.value(forKey: instanceCollectionKey) as? CollectionManager else {
            let collectionManager = CollectionManager(collectionView: self)
            self.layer.setValue(collectionManager, forKey: instanceCollectionKey)
            return collectionManager
        }
        return collectionManager
    }
    
    var sections: [CollectionSection] {
        set { self.collectionManagerInstance().sections = newValue }
        get { return self.collectionManagerInstance().sections }
    }
    
    var sectionsToRender: [CollectionSection] {
        return self.collectionManagerInstance().sectionsToRender
    }
    
    func row(atIndexPath indexPath: IndexPath, includeAll: Bool = false) -> CollectionRow {
        return self.collectionManagerInstance().row(atIndexPath: indexPath)
    }
    
    func section(atIndex index: Int, includeAll: Bool = false) -> CollectionSection {
        return self.collectionManagerInstance().section(atIndex: index)
    }
    
    func indexPath(forRow row: CollectionRow, includeAll: Bool = false) -> IndexPath? {
        return self.collectionManagerInstance().indexPath(forRow: row, includeAll: includeAll) as IndexPath?
    }
    
    func index(forSection section: CollectionSection, includeAll: Bool = false) -> Int? {
        return self.collectionManagerInstance().index(forSection: section, includeAll: includeAll)
    }
    
    @discardableResult
    func addSection(_ section: CollectionSection? = nil) -> CollectionSection {
        return self.collectionManagerInstance().addSection(section)
    }
    
//    @discardableResult
//    func addRow(_ row: CollectionRow? = nil) -> CollectionRow {
//        return self.collectionManagerInstance().addRow(row)
//    }
    
//    @discardableResult
//    func addRow(_ identifier: String) -> CollectionRow {
//        return self.collectionManagerInstance().addRow(identifier)
//    }
    
    @discardableResult
    func addRow<T>(_ type: T.Type, _ config: ((T) -> Void)?) -> CollectionRow {
        if _collectionViewRegisterData[String(describing: type)] == nil {
            _collectionViewRegisterData[String(describing: type)] = self.register(type) ? true : nil
        }
        return self.collectionManagerInstance().addRow(type, config)
    }
    
    func set(_ size: CGSize) {
        self.collectionManagerInstance().set(size)
    }
    
    func clearSections() {
        self.collectionManagerInstance().clearSections()
    }
    
    func clearRows() {
        self.collectionManagerInstance().clearRows()
    }
    
}
