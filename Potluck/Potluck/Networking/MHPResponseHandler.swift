//
//  MHPResponseHandler.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/17/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Receive the data response from the service, sends it to the correct parser per the service used

struct MHPResponseHandler {
    private let service: ServiceOption
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }
}


// MARK: - Parse the response as needed for the service specified (future refactor to use generics so there's only one parser)

class MHPParser: Parseable {
    
}

protocol Parseable {
    
}

class MHPFirestoreParser: MHPParser {
    
}

class MHPRealtimeDBParser: MHPParser {
    
}
