//
//  CNContactExtensions.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/4/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Contacts

extension CNContact: TableViewCompatible {
    private static var _isSelected = [String: Bool]()
    
    var isSelected: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return CNContact._isSelected[tmpAddress] ?? false
        }
        set ( newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            CNContact._isSelected[tmpAddress] = newValue
        }
    }
    
    var reuseIdentifier: String {
        return "MHPContactsCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsMultipleSelection = true
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MHPContactsCell
        cell.configureWithModel(self)
        return cell
    }
}
