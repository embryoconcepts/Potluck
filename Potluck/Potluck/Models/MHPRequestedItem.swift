//
//  MHPRequestedItem.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPRequestedItem: Codable, Equatable, TableViewCompatible {
    var name: String?
    var quantity: Int?
    var quantityType: String?
    
    init() { }
    
    init(name: String?,
         quantity: Int?,
         quantityType: String?) {
        self.name = name
        self.quantity = quantity
        self.quantityType = quantityType
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
