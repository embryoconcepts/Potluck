//
//  Rsvp.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPRsvp: Codable {
    var rsvpID: String?
    var userID: String?
    var eventRsvpList: MHPEventRsvpList?
    var isGuest: Bool?
    var isHost: Bool?
    var response: String?
    var notificationsOn: Bool?
    var numOfGuest: Int?

}

