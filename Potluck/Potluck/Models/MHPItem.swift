//
//  Item.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPItem: Codable {
    var itemID: String = UUID().uuidString
    var user: MHPUser?
    var event: MHPEvent?
    var itemTags: [String]?
    var itemName: String?
    var itemPortions: Int?
    var itemDescription: String?
    var itemPlaceholderName: String?
    var itemSuggestedPortions: Int?
    
}
