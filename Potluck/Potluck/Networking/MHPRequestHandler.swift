//
//  MHPRequestHandler.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/14/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation

//// Set server/service:
// set the correct service in AppDelegate: FirebaseFirestore, FirebaseRealtimeDatabase, AWS *
// where to save this value, if trying to not to use app constants/flags/singletons?
// * (enum for now, will do via plists and Xcode configs later)

enum ServiceOptions {
    case FirebaseFirestore
    case FirebaseRealtimeDatabase
    case AWS
    
    func router() -> ServiceRouter {
        switch self {
        case .FirebaseFirestore:
            return FirebaseFirestoreServiceRouter()
        case .FirebaseRealtimeDatabase:
            return FirebaseRealtimeDBServiceRouter()
        case .AWS:
            return AWSServiceRouter()
        }
    }
    
    func parser() -> Parser {
        switch self {
        case .FirebaseFirestore:
            return FirestoreParser()
        case .FirebaseRealtimeDatabase:
            return RealtimeDBParser()
        case .AWS:
            return AWSParser()
        }
    }
}

//// Make a call
// ViewController makes a generic call to login a user, pass an email and password to RequestHandler


// MARK: - Build the request
// RequestHandler: build the request for the set service, pass request to the correct ServiceRouter
struct RequestHandler {

}


// MARK: - Send a request - use a protocol to insure conformity in the routers
class ServiceRouter { /* only used to return the correct class from the ServiceOptions enum */ }

protocol Routeable {
    
}

// FirebaseFirestoreServiceRouter: send the data to the correct service
class FirebaseFirestoreServiceRouter: ServiceRouter, Routeable {
    
}

// FirebaseRealtimeDBServiceRouter: send the data to the correct service
class FirebaseRealtimeDBServiceRouter: ServiceRouter, Routeable {
    
}

// AWSServiceRouter: send the data to the correct service
class AWSServiceRouter: ServiceRouter, Routeable {
    
}


// MARK: - Receive a response
// ResponseHandler: receive the data response from the service, sends it to the correct parser per the service used
struct ResponseHandler {
    
}


// MARK: - Parse it real good - use a protocol to insure conformity in the parsers
/// * future refactor to use generics so there's only one parser

class Parser { /* only used to return the correct class from the ServiceOptions enum */ }

protocol Mappable {
    
}

// FirestoreParser: map the response to the model
class FirestoreParser: Parser, Mappable {
    
}

// RealtimeDBParser: map the  response to a model
class RealtimeDBParser: Parser, Mappable {
    
}

// AWSParser: map the  response to a model
class AWSParser: Parser, Mappable {
    
}


// MARK: - Complete the call
// return the model to the original caller


