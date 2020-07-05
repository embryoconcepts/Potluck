//
//  File.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCompatible {
    
    var reuseIdentifier: String { get }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    
}

protocol CollectionViewCompatible {
    
    var reuseIdentifier: String { get }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell
    
}

protocol Configurable {
    
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
    
}

protocol TableViewSection {
    
    var sortOrder: Int { get set }
    var items: [TableViewCompatible] { get set }
    var headerTitle: String? { get set }
    var footerTitle: String? { get set }
    
    init(sortOrder: Int, items: [TableViewCompatible], headerTitle: String?, footerTitle: String?)
    
}
