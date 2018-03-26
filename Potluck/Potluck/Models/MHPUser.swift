//
//  User.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPUser: Codable {
    var userID: String?
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userPhone: String?
    var userProfileURL: URL?
    var userFacebookID: String?
    var isRegistered: Bool?
    var userEventListID: String?
    var notificationPermissions: Bool?
    var notificationPreferences: Bool?
    var locationPermissions: Bool?
    var facebookPermissions: Bool?
    
}
