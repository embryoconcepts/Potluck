//
//  Item.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPPledgedItem: Codable {
    var itemID: String?
    var userID: String?
    var eventID: String?
    var tags: [String]?
    var name: String?
    var quantity: Int?
    var quantityType: String?
    var description: String?

    init() {

    }

    init(itemID: String = UUID().uuidString,
         userID: String?,
         eventID: String?,
         tags: [String]?,
         name: String?,
         quantity: Int?,
         quantityType: String?,
         description: String?) {

        self.itemID = itemID
        self.userID = userID
        self.eventID = eventID
        self.tags = tags
        self.name = name
        self.quantity = quantity
        self.quantityType = quantityType
        self.description = description
    }
}
