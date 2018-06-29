//
//  MHPInvite.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPInvite: Codable, TableViewCompatible {
    var userID: String?
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userPhone: String?
    var userProfileURL: String?
    var userFacebookID: String?
    var eventID: String?
    
    var reuseIdentifier: String {
        return "MHPCreateEventInvitesCell"
    }
    
    init(userFirstName: String,
         userLastName: String) {
        
        self.userFirstName = userFirstName
        self.userLastName = userLastName
    }
    
    init(userID: String?,
         userFirstName: String?,
         userLastName: String?,
         userEmail: String?,
         userPhone: String?,
         userProfileURL: String?,
         userFacebookID: String?,
         eventID: String?) {
    
        self.userID = userID
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userEmail = userEmail
        self.userPhone = userPhone
        self.userProfileURL = userProfileURL
        self.userFacebookID = userFacebookID
        self.eventID = eventID
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MHPCreateEventInvitesCell
        cell.configureWithModel(self)
        return cell
    }
}
