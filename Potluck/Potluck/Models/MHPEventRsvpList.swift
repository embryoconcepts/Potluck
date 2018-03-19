//
//  EventRsvpList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEventRsvpList: Codable {
    var eventRsvpListID: String?
    var eventHost: MHPUser?
    var eventRsvps: [MHPRsvp]?

}
