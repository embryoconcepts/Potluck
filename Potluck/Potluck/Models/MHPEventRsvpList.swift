//
//  EventRsvpList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEventRsvpList: Codable  {
    var eventRsvpListID: String?
    var eventHostID: String?
    var eventRsvps: [MHPRsvp]?

    init(eventRsvpListID: String = UUID().uuidString) {
        self.eventRsvpListID = eventRsvpListID
    }
    
    init(eventRsvpListID: String = UUID().uuidString,
         eventHostID: String?,
         eventRsvps: [MHPRsvp]?) {
        
        self.eventRsvpListID = eventRsvpListID
        self.eventHostID = eventRsvpListID
        self.eventRsvps = eventRsvps
    }
}
