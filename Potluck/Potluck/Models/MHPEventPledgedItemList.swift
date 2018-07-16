//
//  EventItemList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEventPledgedItemList: Codable  {
    var listID: String?
    var eventID: String?
    var description: String?
    var tags: [String]?
    var items: [MHPPledgedItem]?

    init(itemListID: String = UUID().uuidString) {
        self.listID = itemListID
    }
    
    init(listID: String = UUID().uuidString,
         eventID: String?,
         description: String?,
         tags: [String]?,
         items: [MHPPledgedItem]?) {
        
    self.listID = listID
    self.eventID = eventID
    self.description = description
    self.tags = tags
    self.items = items
    }
}
