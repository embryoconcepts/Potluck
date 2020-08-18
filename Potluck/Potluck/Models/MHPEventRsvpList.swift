//
//  EventRsvpList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEventRsvpList: Codable {
    var listID: String?
    var hostID: String?
    var rsvps: [MHPRsvp]?

    init(listID: String = UUID().uuidString) {
        self.listID = listID
    }

    init(listID: String = UUID().uuidString,
         hostID: String?,
         rsvps: [MHPRsvp]?) {

        self.listID = listID
        self.hostID = hostID
        self.rsvps = rsvps
    }
}
