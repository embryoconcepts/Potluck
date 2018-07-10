//
//  MHPRequestedItem.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPRequestedItem: Codable, TableViewCompatible {
    var itemName: String?
    var itemPortions: Int?
    var itemPlaceholderName: String?
    var itemSuggestedPortions: Int?
    
    init() {

    }
    
    init(itemName: String?,
         itemPortions: Int?,
         itemPlaceholderName: String?,
         itemSuggestedPortions: Int?) {
        
        self.itemName = itemName
        self.itemPortions = itemPortions
        self.itemPlaceholderName = itemPlaceholderName
        self.itemSuggestedPortions = itemSuggestedPortions
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
