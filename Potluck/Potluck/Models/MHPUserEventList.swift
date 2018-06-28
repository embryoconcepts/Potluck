//
//  UserEventList.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/13/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

struct MHPUserEventList: Codable  {
    var userEventListID: String = UUID().uuidString
    var userID: String?
    var userEvents: [MHPEvent]?
    
}
