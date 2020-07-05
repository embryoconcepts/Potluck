//
//  UserEventList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPUserEventList: Codable {
    var listID: String?
    var userID: String?
    var events: [MHPEvent]?

    init(listID: String = UUID().uuidString) {
        self.listID = listID
    }

    init(listID: String = UUID().uuidString,
         userID: String?,
         events: [MHPEvent]) {

            self.listID = listID
            self.userID = userID
            self.events = events
        }
}
