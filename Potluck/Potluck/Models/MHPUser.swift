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
    case unset
}

struct MHPUser: Codable {
    var userID: String?
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userPhone: String?
    var userProfileURL: URL?
    var userFacebookID: String?
    var userEventListID: String?
    var notificationPermissions: Bool?
    var notificationPreferences: Bool?
    var locationPermissions: Bool?
    var facebookPermissions: Bool?
    var userState: UserAuthorizationState = .unset
    
//    init(from decoder: Decoder) throws {
//        
//    }
    
//    init(userID: String,
//         userFirstName: String,
//         userLastName: String,
//         userEmail: String,
//         userPhone: String,
//         userProfileURL: URL,
//         userFacebookID: String,
//         userEventListID: String,
//         notificationPermissions: Bool,
//         notificationPreferences: Bool,
//         locationPermissions: Bool,
//         facebookPermissions: Bool,
//         userState: UserAuthorizationState) {
//        
//        self.userID = userID
//        self.userFirstName = userFirstName
//        self.userLastName = userLastName
//        self.userEmail = userEmail
//        self.userPhone = userPhone
//        self.userProfileURL = userProfileURL
//        self.userFacebookID = userFacebookID
//        self.userEventListID = userEventListID
//        self.notificationPermissions = notificationPermissions
//        self.notificationPreferences = notificationPreferences
//        self.locationPermissions = locationPermissions
//        self.facebookPermissions = facebookPermissions
//        self.userState = userState
//    }
}
