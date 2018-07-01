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
    var itemPortions: Int?
    var itemDescription: String?
    var itemPlaceholderName: String?
    var itemSuggestedPortions: Int?
    
    init(itemID: String = UUID().uuidString) {
        self.itemID = itemID
    }
    
    init(itemID: String = UUID().uuidString,
         userID: String?,
         eventID: String?,
         itemTags: [String]?,
         itemName: String?,
         itemPortions: Int?,
         itemDescription: String?,
         itemPlaceholderName: String?,
         itemSuggestedPortions: Int?) {
        
        self.itemID = itemID
        self.userID = userID
        self.eventID = eventID
        self.itemTags = itemTags
        self.itemName = itemName
        self.itemPortions = itemPortions
        self.itemDescription = itemDescription
        self.itemPlaceholderName = itemPlaceholderName
        self.itemSuggestedPortions = itemSuggestedPortions
    }
}
