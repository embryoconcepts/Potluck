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
    var invite: MHPInvite?
    var user: MHPUser?
    var event: MHPEvent?
    var item: MHPItem?
    var isGuest: Bool?
    var isHost: Bool?
    var response: String?
    var notificationsOn: Bool?
    var numOfGuest: Int?

    init(rsvpID: String = UUID().uuidString) {
        self.rsvpID = rsvpID
    }
}
