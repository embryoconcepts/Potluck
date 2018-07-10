//
//  EventItemList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEventItemList: Codable  {
    var eventItemListID: String?
    var eventID: String?
    var eventItemListDescription: String?
    var eventItemListTags: [String]?
    var eventItems: [MHPRequestedItem]?

    init(itemListID: String = UUID().uuidString) {
        self.eventItemListID = itemListID
    }
    
    init(eventItemListID: String = UUID().uuidString,
         eventID: String?,
         eventItemListDescription: String?,
         eventItemListTags: [String]?,
         eventItems: [MHPRequestedItem]?) {
        
    self.eventItemListID = eventItemListID
    self.eventID = eventID
    self.eventItemListDescription = eventItemListDescription
    self.eventItemListTags = eventItemListTags
    self.eventItems = eventItems
    }
}
