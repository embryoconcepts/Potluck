//
//  Event.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEvent: Codable {
    var eventID: String
    var title: String?
    var date: String?
    var location: String?
    var address: String?
    var description: String?
    var imageURL: String?
    var restrictionDescription: String?
    var restrictions: [String]?
    var host: MHPUser?
    var requestedItems: [MHPRequestedItem]?
    var pledgedItemList: MHPEventPledgedItemList?
    var invites: [MHPInvite]?
    var rsvpList: MHPEventRsvpList?
    
    init(eventID: String = UUID().uuidString) {
        self.eventID = eventID
    }
    
    init(eventID: String = UUID().uuidString,
         title: String?,
         date: String?,
         location: String?,
         address: String?,
         description: String?,
         imageURL: String?,
         restrictionDescription: String?,
         restrictions: [String]?,
         host: MHPUser?,
         requestedItems: [MHPRequestedItem]?,
         pledgedItemList: MHPEventPledgedItemList?,
         invites: [MHPInvite]?,
         rsvpList: MHPEventRsvpList?) {
        
        self.eventID = eventID
        self.title = title
        self.date = date
        self.location = location
        self.address = address
        self.description = description
        self.imageURL = imageURL
        self.restrictionDescription = restrictionDescription
        self.restrictions = restrictions
        self.host = host
        self.requestedItems = requestedItems
        self.pledgedItemList = pledgedItemList
        self.invites = invites
        self.rsvpList = rsvpList
    }
}
