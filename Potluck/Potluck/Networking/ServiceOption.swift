//
//  ServiceOption.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/17/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation


// MARK: - Set the correct service in AppDelegate (enum for now, will do via plists and Xcode configs later)

enum ServiceOption {
    case FirebaseFirestore
    case FirebaseRealtimeDatabase
//    case URLService
    
    var router: MHPServiceRouter {
        switch self {
        case .FirebaseFirestore:
            return MHPFirebaseFirestoreServiceRouter()
        case .FirebaseRealtimeDatabase:
            return MHPFirebaseRealtimeDBServiceRouter()
        }
    }
    
    var parser: MHPParser {
        switch self {
        case .FirebaseFirestore:
            return MHPFirestoreParser()
        case .FirebaseRealtimeDatabase:
            return MHPRealtimeDBParser()
        }
    }
}

