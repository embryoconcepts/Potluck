//
//  Event.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPEvent: NSObject {
    var eventID: String
    var eventName: String?
    var eventDate: String?
    var eventLocation: String?
    var eventDescription: String?
    var eventImageURL: String?
    var eventHostID: MHPUser?
    var eventItemList: MHPEventItemList?
    var eventRsvpList: MHPEventRsvpList?
    
    init(eventID: String) {
        self.eventID = eventID
    }
    
    init(eventID: String, eventName: String?, eventDate:String?, eventLocation:String?, eventDescription:String?, eventImageURL:String?, eventHostID:MHPUser?, eventItemList:MHPEventItemList?, eventRsvpList:MHPEventRsvpList?) {
       
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
        if let tempEventImageURL = eventImageURL {
            self.eventImageURL = tempEventImageURL
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

