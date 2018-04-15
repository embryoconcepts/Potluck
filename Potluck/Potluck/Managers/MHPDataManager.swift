//
//  MHPDataManager.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 4/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

struct DataManager {
    
    func parseResponseToUser(document: DocumentSnapshot, data: [String:Any]) -> MHPUser {
        var user = MHPUser()
        user.userID = document.documentID
        user.userFirstName = data["userFirstName"] as? String ?? ""
        user.userLastName = data["userLastName"] as? String ?? ""
        user.userEmail = data["userEmail"] as? String ?? ""
        user.userPhone = data["userPhone"] as? String ?? ""
        user.userProfileURL = URL(string: data["userProfileURL"] as? String ?? "")
        user.userFacebookID = data["userFacebookID"] as? String ?? ""
        user.userEventListID = data["userEventListID"] as? String ?? ""
        user.notificationPermissions = data["notificationPermissions"] as? Bool ?? false
        user.notificationPreferences = data["notificationPreferences"] as? Bool ?? false
        user.locationPermissions = data["locationPermissions"] as? Bool ?? false
        user.facebookPermissions = data["facebookPermissions"] as? Bool ?? false
        user.userState = data["userState"] as? UserAuthorizationState ?? .unknown
        let state = data["userState"] as? String ?? "unknown"
        switch state {
        case "unverified":
            user.userState = .unverified
        case "verified":
            user.userState = .verified
        case "registered":
            user.userState = .registered
        default:
            user.userState = .unknown
        }
        
        return user
    }
    
}
