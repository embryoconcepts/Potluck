//
//  Item.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPItem: Codable {
    var itemID: String?
    var userID: String?
    var eventID: String?
    var itemTags: [String]?
    var itemName: String?
    var itemQuantity: Int?
    var itemQuantityType: String?
    var itemDescription: String?
    
    init(itemID: String = UUID().uuidString) {
        self.itemID = itemID
    }
    
    init(itemID: String = UUID().uuidString,
         userID: String?,
         eventID: String?,
         itemTags: [String]?,
         itemName: String?,
         itemQuantity: Int?,
         itemQuantityType: String?,
         itemDescription: String?) {
        
        self.itemID = itemID
        self.userID = userID
        self.eventID = eventID
        self.itemTags = itemTags
        self.itemName = itemName
        self.itemQuantity = itemQuantity
        self.itemQuantityType = itemQuantityType
        self.itemDescription = itemDescription
    }
}
