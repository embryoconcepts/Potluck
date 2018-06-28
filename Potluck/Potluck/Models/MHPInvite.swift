//
//  MHPInvite.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPInvite: Codable, TableViewCompatible {
    var inviteID: String = UUID().uuidString
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userPhone: String?
    var userProfileURL: URL?
    var userFacebookID: String?
    var eventID: MHPEvent?
    
    var reuseIdentifier: String {
        return "inviteCell"
    }
    
    init(userFirstName: String, userLastName: String) {
        self.userFirstName = userFirstName
        self.userLastName = userLastName
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MHPCreateEventInvitesCell
        cell.configureWithModel(self)
        return cell
    }
}