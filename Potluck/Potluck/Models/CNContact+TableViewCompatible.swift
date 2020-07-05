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
    private static var _contactPreference = [String: String]()

    var isSelected: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return CNContact._isSelected[tmpAddress] ?? false
        }
        set (newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            CNContact._isSelected[tmpAddress] = newValue
        }
    }

    var contactPreference: String? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return CNContact._contactPreference[tmpAddress] ?? ""
        }
        set (newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            CNContact._contactPreference[tmpAddress] = newValue
        }
    }

    var reuseIdentifier: String {
        return "MHPContactsCell"
    }

    var emails: [String] {
        var tempEmails = [String]()
        for email in self.emailAddresses {
            tempEmails.append(email.value.description)
        }
        return tempEmails
    }

    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsMultipleSelection = true
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? MHPContactsCell else { return UITableViewCell() }
        cell.configureWithModel(self)
        return cell
    }
}
