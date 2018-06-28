//
//  MHPInvite.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPInvite: Codable, TableViewCompatible {
    var inviteID: String?
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userPhone: String?
    var userProfileURL: URL?
    var userFacebookID: String?
    var eventID: MHPEvent?
    
    var reuseIdentifier: String {
        return "MHPCreateEventInvitesCell"
    }
    
    init(userFirstName: String, userLastName: String, inviteID: String = UUID().uuidString) {
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.inviteID = inviteID
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MHPCreateEventInvitesCell
        cell.configureWithModel(self)
        return cell
    }
}
