//
//  Item.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class Item: NSObject {
    var itemID: String
    var user: User?
    var eventItemList: EventItemList?
    var itemTags: [String]?
    var itemName: String?
    var itemPortions: Int?
    var itemDescription: String?
    var itemPlaceholderName: String?
    var itemSuggestedPortions: Int?
    
    init(itemID: String, user: User?, eventItemList: EventItemList?, itemTags: [String]?, itemName: String?, itemPortions: Int?, itemDescription: String?, itemPlaceholderName: String?, itemSuggestedPortions: Int?) {
        
        self.itemID = itemID
        
        if let tempUser = user {
            self.user = tempUser
        }
        if let tempItemList = eventItemList {
            self.eventItemList = tempItemList
        }
        if let tempTags = itemTags {
            self.itemTags = tempTags
        }
        if let tempName = itemName {
            self.itemName = tempName
        }
        if let tempPortions = itemPortions {
            self.itemPortions = tempPortions
        }
        if let tempDesc = itemDescription {
            self.itemDescription = tempDesc
        }
        if let tempPlaceholder = itemPlaceholderName {
            self.itemPlaceholderName = tempPlaceholder
        }
        if let tempSuggested = itemSuggestedPortions {
            self.itemSuggestedPortions = tempSuggested
        }
    }
}
