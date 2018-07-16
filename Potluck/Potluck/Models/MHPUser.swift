//
//  User.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

enum UserAuthorizationState: String, Codable {
    /// not registered or logged in
    case anonymous
    /// initial sign up complete, email not verified
    case unverified
    /// email or phone verified, but basic profile details incomplete, not in database
    case verified
    /// verified and confirmed, basic profile complete, added to database
    case registered
    /// default value
//    case unset
}

struct MHPUser: Codable {
    var userID: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var profileImageURL: String?
    var facebookID: String?
    var eventListID: String?
    var notificationPermissions: Bool?
    var notificationPreferences: Bool?
    var locationPermissions: Bool?
    var facebookPermissions: Bool?
    var userState: UserAuthorizationState!
    
    init(userState: UserAuthorizationState = .anonymous) {
        self.userState = userState
    }
    
    init(userID: String,
         firstName: String,
         lastName: String,
         email: String,
         phone: String,
         profileImageURL: String,
         facebookID: String,
         eventListID: String,
         notificationPermissions: Bool,
         notificationPreferences: Bool,
         locationPermissions: Bool,
         facebookPermissions: Bool,
         userState: UserAuthorizationState) {
        
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.profileImageURL = profileImageURL
        self.facebookID = facebookID
        self.eventListID = eventListID
        self.notificationPermissions = notificationPermissions
        self.notificationPreferences = notificationPreferences
        self.locationPermissions = locationPermissions
        self.facebookPermissions = facebookPermissions
        self.userState = userState
    }
}
