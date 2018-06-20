//
//  MHPParser.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/19/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

/// Parse the response as needed for the service specified (future refactor to use generics so there's only one parser)
class MHPParser: Parseable {
    func buildDataSet(firUserEmail: String?, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any] { return [String: Any]() }
    func parseResponseToUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser { return MHPUser() }
}

protocol Parseable {
    
}

class MHPFirestoreParser: MHPParser {
    override func buildDataSet(firUserEmail: String?, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any] {
        var userDict = [String: Any]()
        userDict["userState"] = state.rawValue
        
        if let mu = mhpUser {
            userDict["userFirstName"] = mu.userFirstName
            userDict["userFirstName"] = mu.userFirstName
            userDict["userLastName"] = mu.userLastName
            userDict["userEmail"] = mu.userEmail
            userDict["userPhone"] = mu.userPhone
            userDict["userProfileURL"] = mu.userProfileURL
            userDict["userFacebookID"] = mu.userFacebookID
            userDict["userEventListID"] = mu.userEventListID
            userDict["notificationPermissions"] = mu.notificationPermissions
            userDict["notificationPreferences"] = mu.notificationPreferences
            userDict["locationPermissions"] = mu.locationPermissions
            userDict["facebookPermissions"] = mu.facebookPermissions 
        } else if let fn = firstName, let ln = lastName {
            userDict["userFirstName"] = fn
            userDict["userLastName"] = ln
        }
        
        if let email = firUserEmail {
            userDict["userEmail"] = email
        }
        return userDict
    }
    
    override func parseResponseToUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return MHPUser() }
        guard var user = try? JSONDecoder().decode(MHPUser.self, from: jsonData) else { return MHPUser() }
        user.userID = document.documentID
        let state = data["userState"] as! String
        switch state {
        case "unverified":
            user.userState = .unverified
        case "verified":
            user.userState = .verified
        case "registered":
            user.userState = .registered
        case "anonymous":
            user.userState = .anonymous
        default:
            user.userState = .unset
        }
        return user
    }
    
}

class MHPRealtimeDBParser: MHPParser {
    
}
