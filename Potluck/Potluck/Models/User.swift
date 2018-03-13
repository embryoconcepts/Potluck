//
//  User.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class User: NSObject {
    var userID: String
    var userName: String?
    var userEmail: String?
    var userPhone: String?
    var userProfileURL: URL?
    var userFacebookID: String?
    var isRegistered: Bool
    var userEventList: UserEventList?
    var notificationPermissions: Bool?
    var notificationPreferences: Bool?
    var locationPermissions: Bool?
    var facebookPermissions: Bool?
    
    init(userID: String, userName: String?, userEmail: String?, userPhone: String?, userProfileURLString: String?, userFacebookID: String?, isRegistered: Bool?, userEventList: UserEventList?, notificationPermissions: Bool?, notificationPreferences: Bool?, locationPermissions: Bool?, facebookPermissions: Bool?) {
        
        self.userID = userID
       
        if let tempName = userName {
            self.userName = tempName
        }
        if let tempUserEmail = userEmail {
            self.userEmail = tempUserEmail
        }
        if let tempUserPhone = userPhone {
            self.userPhone = tempUserPhone
        }
        if let tempProfileURLString = userProfileURLString {
            self.userProfileURL = URL(string: tempProfileURLString)
        }
        if let tempFacebookID = userFacebookID {
            self.userFacebookID = tempFacebookID
        }
        if let tempRegistered = isRegistered {
            self.isRegistered = tempRegistered
        } else {
            self.isRegistered = false
        }
        if let tempEventList = userEventList {
            self.userEventList = tempEventList
        }
        if let tempNotifPermissions = notificationPermissions {
            self.notificationPermissions = tempNotifPermissions
        }
        if let tempNotifPrefs = notificationPreferences {
            self.notificationPreferences = tempNotifPrefs
        }
        if let tempLocationPermissions = locationPermissions {
            self.locationPermissions = tempLocationPermissions
        }
        if let tempFBPermissions = facebookPermissions {
            self.facebookPermissions = tempFBPermissions
        }
    }
}
