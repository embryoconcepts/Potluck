//
//  User.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

enum UserAuthorizationState: String {
    /// not registered or logged in
    case unknown
    /// initial sign up complete, email not verified
    case unverified
    /// email or phone verified, but basic profile details incomplete, not in database
    case verified
    /// verified and confirmed, basic profile complete, added to database
    case registered
}

struct MHPUser {
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
    var userState: UserAuthorizationState!
}
