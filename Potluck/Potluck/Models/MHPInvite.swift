//
//  MHPInvite.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPInvite: Codable, Equatable, TableViewCompatible {
    //swiftlint:disable operator_whitespace
    static func ==(lhs: MHPInvite, rhs: MHPInvite) -> Bool {
        return
            lhs.email == rhs.email ||
            lhs.contactID == rhs.contactID
    }

    var userID: String?
    var userFirstName: String?
    var userLastName: String?
    var email: String?
    var userPhone: String?
    var userProfileURL: String?
    var userFacebookID: String?
    var eventID: String?
    var contactID: String?
    var contactImage: Data?

    var reuseIdentifier: String {
        return "MHPCreateEventInvitesCell"
    }

    init(userFirstName: String,
         userLastName: String,
         email: String) {

        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.email = email
    }

    init(userID: String?,
         userFirstName: String?,
         userLastName: String?,
         email: String?,
         userPhone: String?,
         userProfileURL: String?,
         userFacebookID: String?,
         eventID: String?,
         contactID: String?,
         contactImage: Data?) {

        self.userID = userID
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.email = email
        self.userPhone = userPhone
        self.userProfileURL = userProfileURL
        self.userFacebookID = userFacebookID
        self.eventID = eventID
        self.contactID = contactID
        self.contactImage = contactImage
    }

    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? MHPCreateEventInvitesCell else { return UITableViewCell() }
        cell.configureWithModel(self)
        return cell
    }
}
