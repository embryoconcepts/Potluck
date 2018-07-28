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
    func buildUserDataSet(firUserEmail: String?, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any] { return [String: Any]() }
    func parseResponseToUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser? { return nil }
    
    func buildEventDataSet(event: MHPEvent) -> [String: Any] { return [String: Any]() }
    func parseResponseToEvent(document: DocumentSnapshot, data: [String: Any]) -> MHPEvent? { return nil }
}

protocol Parseable {
    
}

class MHPFirestoreParser: MHPParser {
    
    
    // MARK: - User Parsing
    
    override func buildUserDataSet(firUserEmail: String?, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any] {
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
        var user = MHPUser()
        do {
            user = try user.dictToModel(dict: data)
        } catch let err {
            print("parseResponseToUser error:\(err)")
        }
        return user
    }
    
    
    // MARK: - Event Parsing
    
    override func buildEventDataSet(event: MHPEvent) -> [String: Any] {
        var eventDict = [String: Any]()
        do {
            eventDict = try event.modelToDict()
        } catch let err {
            print("buildEventDataSet error:\(err)")
        }
        return eventDict
    }
    
    override func parseResponseToEvent(document: DocumentSnapshot, data: [String: Any]) -> MHPEvent? {
        var event = MHPEvent()
        do {
            event = try event.dictToModel(dict: data)
        } catch let err {
            print("parseResponseToUser error:\(err)")
        }
        return event
    }
    
}



class MHPRealtimeDBParser: MHPParser {
    
}
