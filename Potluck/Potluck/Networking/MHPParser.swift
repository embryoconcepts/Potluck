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
    func parseResponseToUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser? { return nil }
}

protocol Parseable {
    
}

class MHPFirestoreParser: MHPParser {
    override func buildDataSet(firUserEmail: String?, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any] {
        var userDict = [String: Any]()
        userDict["userState"] = state.rawValue
        
        if let email = firUserEmail {
            userDict["userEmail"] = email
        }
        
        if let mu = mhpUser {
            userDict["firstName"] = mu.firstName
            userDict["lastName"] = mu.lastName
            userDict["email"] = mu.email ?? firUserEmail
            userDict["phone"] = mu.phone
            userDict["profileImageURL"] = mu.profileImageURL
            userDict["facebookID"] = mu.facebookID
            userDict["eventListID"] = mu.eventListID
            userDict["notificationPermissions"] = mu.notificationPermissions
            userDict["notificationPreferences"] = mu.notificationPreferences
            userDict["locationPermissions"] = mu.locationPermissions
            userDict["facebookPermissions"] = mu.facebookPermissions
        } else if let fn = firstName, let ln = lastName {
            userDict["firstName"] = fn
            userDict["lastName"] = ln
        }
        return userDict
    }
    
    override func parseResponseToUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return nil }
        guard var user = try? JSONDecoder().decode(MHPUser.self, from: jsonData) else { return nil }
        user.userID = document.documentID
        let state = data["userState"] as! String
        switch state {
        case "unverified":
            user.userState = .unverified
        case "verified":
            user.userState = .verified
        case "registered":
            user.userState = .registered
        default:
            user.userState = .anonymous
        }
        return user
    }
    
}

class MHPRealtimeDBParser: MHPParser {
    
}
