//
//  Event.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEvent: Codable {
    var eventID: String?
    var eventName: String?
    var eventDate: String?
    var eventLocation: String?
    var eventAddress: String?
    var eventDescription: String?
    var eventImageURL: String?
    var eventRestrictions: [String]?
    var eventHostID: String?
    var eventItemListID: String?
    var eventRsvpListID: String?
    
    init(eventID: String = UUID().uuidString) {
        self.eventID = eventID
    }
    
    init(eventID: String = UUID().uuidString,
         eventName: String?,
         eventDate: String?,
         eventLocation: String?,
         eventAddress: String?,
         eventDescription: String?,
         eventImageURL: String?,
         eventRestrictions: [String]?,
         eventHostID: String?,
         eventItemListID: String?,
         eventRsvpListID: String?) {
        
        self.eventID = eventID
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventAddress = eventAddress
        self.eventDescription = eventDescription
        self.eventImageURL = eventImageURL
        self.eventHostID = eventHostID
        self.eventItemListID = eventItemListID
        self.eventRsvpListID = eventRsvpListID
    }
}
