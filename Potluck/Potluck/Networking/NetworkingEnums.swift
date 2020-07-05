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
    case firebaseFirestore
    case firebaseRealtimeDatabase

    var router: MHPServiceRouter {
        switch self {
        case .firebaseFirestore:
            return MHPFirebaseFirestoreServiceRouter()
        case .firebaseRealtimeDatabase:
            return MHPFirebaseRealtimeDBServiceRouter()
        }
    }

    var parser: MHPParser {
        switch self {
        case .firebaseFirestore:
            return MHPFirestoreParser()
        case .firebaseRealtimeDatabase:
            return MHPRealtimeDBParser()
        }
    }
}

enum OtherError: Error {
    case noUserToRetrieve
}
