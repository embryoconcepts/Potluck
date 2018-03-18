//
//  Rsvp.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPRsvp: NSObject {
    var rsvpID: String
    var user: MHPUser?
    var eventRsvpList: MHPEventRsvpList?
    var isGuest: Bool?
    var isHost: Bool?
    var response: String?
    var notificationsOn: Bool?
    var numOfGuest: Int?
    
    init(rsvpID: String) {
        self.rsvpID = rsvpID
    }
    
    init(rsvpID: String, user: MHPUser?, eventRsvpList:MHPEventRsvpList?, isGuest:Bool?, isHost:Bool?, response:String?, notificationsOn:Bool?, numOfGuest:Int?) {
       
        self.rsvpID = rsvpID
       
        if let tempUser = user {
            self.user = tempUser
        }
        if let tempRsvpList = eventRsvpList {
            self.eventRsvpList = tempRsvpList
        }
        if let tempIsGuest = isGuest {
            self.isGuest = tempIsGuest
        }
        if let tempIsHost = isHost {
            self.isHost = tempIsHost
        }
        if let tempResponse = response {
            self.response = tempResponse
        }
        if let tempNotifications = notificationsOn {
            self.notificationsOn = tempNotifications
        }
        if let tempNumGuests = numOfGuest {
            self.numOfGuest = tempNumGuests
        }
    }
}

