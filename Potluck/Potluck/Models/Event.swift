//
//  Event.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class Event: NSObject {
    var eventID: String
    var eventName: String?
    var eventDate: Date?
    var eventLocation: String?
    var eventDescription: String?
    var eventHostID: User?
    var eventItemList: EventItemList?
    var eventRsvpList: EventRsvpList?
    
    init(eventID: String) {
        self.eventID = eventID
    }
    
    init(eventID: String, eventName: String?, eventDate: Date?, eventLocation: String?, eventDescription: String?, eventHostID: User?, eventItemList: EventItemList?, eventRsvpList: EventRsvpList?) {
       
        self.eventID = eventID
        
        if let tempEventName = eventName {
            self.eventName = tempEventName
        }
        if let tempEventDate = eventDate {
            self.eventDate = tempEventDate
        }
        if let tempEventLocation = eventLocation {
            self.eventLocation = tempEventLocation
        }
        if let tempEventDescription = eventDescription {
            self.eventDescription = tempEventDescription
        }
        if let tempEventHostID = eventHostID {
            self.eventHostID = tempEventHostID
        }
        if let tempEventItemList = eventItemList {
            self.eventItemList = tempEventItemList
        }
        if let tempEventRsvpList = eventRsvpList {
            self.eventRsvpList = tempEventRsvpList
        }
    }
}
