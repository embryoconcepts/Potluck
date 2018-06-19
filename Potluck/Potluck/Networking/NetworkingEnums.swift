//
//  ServiceOption.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/17/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation


protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

protocol UserHandler {
    func handleUser()
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

enum ServiceOption {
    case FirebaseFirestore
    case FirebaseRealtimeDatabase
    
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

