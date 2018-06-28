//
//  EventItemList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPEventItemList: Codable  {
    var eventItemListID: String = UUID().uuidString
    var eventID: String?
    var eventItemListDescription: String?
    var eventItemListTags: [String]?
    var eventItems: [MHPItem]?

}
