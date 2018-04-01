//
//  Event.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEvent {
    var eventID: String?
    var eventName: String?
    var eventDate: String?
    var eventLocation: String?
    var eventDescription: String?
    var eventImageURL: String?
    var eventHost: MHPUser?
    var eventItemList: MHPEventItemList?
    var eventRsvpList: MHPEventRsvpList?
    
}
