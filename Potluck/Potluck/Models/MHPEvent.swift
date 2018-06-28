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
    var eventHost: MHPUser?
    var eventItemList: MHPEventItemList?
    var eventRsvpList: MHPEventRsvpList?
    
    init(eventID: String = UUID().uuidString) {
        self.eventID = eventID
    }
    
    init(eventID: String?,
         eventName: String?,
         eventDate: String?,
         eventLocation: String?,
         eventAddress: String?,
         eventDescription: String?,
         eventImageURL: String?,
         eventHost: MHPUser?,
         eventItemList: MHPEventItemList?,
         eventRsvpList: MHPEventRsvpList?) {
        
        self.eventID = eventID
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventAddress = eventAddress
        self.eventDescription = eventDescription
        self.eventImageURL = eventImageURL
        self.eventHost = eventHost
        self.eventItemList = eventItemList
        self.eventRsvpList = eventRsvpList
    }
}
