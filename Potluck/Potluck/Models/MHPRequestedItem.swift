//
//  MHPRequestedItem.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPRequestedItem: Codable, Equatable, TableViewCompatible {
    var itemName: String?
    var itemQuantity: Int?
    var itemQuantityType: String?
    
    init() { }
    
    init(itemName: String?,
         itemQuantity: Int?,
         itemQuantityType: String?) {
        self.itemName = itemName
        self.itemQuantity = itemQuantity
        self.itemQuantityType = itemQuantityType
    }
    
    var reuseIdentifier: String {
        return "MHPRequestedItemsCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MHPRequestedItemsCell
        cell.configureWithModel(self)
        return cell
    }
}
