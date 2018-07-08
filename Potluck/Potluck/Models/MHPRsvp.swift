//
//  Rsvp.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPRsvp: Codable {
    var rsvpID: String?
    var userID: String?
    var userEmail: String?
    var eventID: String?
    var itemID: String?
    var isGuest: Bool?
    var isHost: Bool?
    var response: String?
    var notificationsOn: Bool?
    var numOfGuest: Int?
    
    init(rsvpID: String = UUID().uuidString) {
        self.rsvpID = rsvpID
    }
    
    init(rsvpID: String = UUID().uuidString,
         userID: String?,
         userEmail: String?,
         eventID: String?,
         itemID: String?,
         isGuest: Bool?,
         isHost: Bool?,
         response: String?,
         notificationsOn: Bool?,
         numOfGuest: Int?) {
        
        self.rsvpID = rsvpID
        self.userID = userID
        self.userEmail = userEmail
        self.eventID = eventID
        self.itemID = itemID
        self.isGuest = isGuest
        self.isHost = isHost
        self.response = response
        self.notificationsOn = notificationsOn
        self.numOfGuest = numOfGuest
    }
}
