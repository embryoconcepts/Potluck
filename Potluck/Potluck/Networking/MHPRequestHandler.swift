//
//  MHPRequestHandler.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/14/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase


// MARK: - Set the correct service in AppDelegate (enum for now, will do via plists and Xcode configs later)

enum ServiceOption {
    case FirebaseFirestore
    case FirebaseRealtimeDatabase
    case AWS
    
    func router() -> MHPServiceRouter {
        switch self {
        case .FirebaseFirestore:
            return MHPFirebaseFirestoreServiceRouter()
        case .FirebaseRealtimeDatabase:
            return MHPFirebaseRealtimeDBServiceRouter()
        case .AWS:
            return MHPAWSServiceRouter()
        }
    }
    
    func parser() -> MHPParser {
        switch self {
        case .FirebaseFirestore:
            return MHPFirestoreParser()
        case .FirebaseRealtimeDatabase:
            return MHPRealtimeDBParser()
        case .AWS:
            return MHPAWSParser()
        }
    }
}


// MARK: - Build the request for the set service, pass request to the correct ServiceRouter

struct MHPRequestHandler {
    private let service: ServiceOption
    
    init(service: ServiceOption = .FirebaseFirestore) {
        self.service = service
    }
    
    func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router().sendResetPasswordEmail(forEmail: email) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: - Send a request - use a protocol to insure conformity in the routers
class MHPServiceRouter {
    func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {}
}

protocol Routeable {
}

// FirebaseFirestoreServiceRouter: send the data to the correct service
class MHPFirebaseFirestoreServiceRouter: MHPServiceRouter, Routeable {
    // FIXME: would prefer to use stucts and protocols here, but enum func return seems to force class/subclass
    override func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/resetPassword/?email=\(email)")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion(.success(true))
            } else {
                completion(.failure(error!))
                print("Reset password error: \(String(describing: error))")
            }
        }
    }
}

// FirebaseRealtimeDBServiceRouter: send the data to the correct service
class MHPFirebaseRealtimeDBServiceRouter: MHPServiceRouter, Routeable {
    override func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        
    }
}

// AWSServiceRouter: send the data to the correct service
class MHPAWSServiceRouter: MHPServiceRouter, Routeable {
    override func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        
    }
}


// MARK: - Receive the data response from the service, sends it to the correct parser per the service used
struct ResponseHandler {
    private let service: ServiceOption
    
    init(service: ServiceOption = .FirebaseFirestore) {
        self.service = service
    }
}


// MARK: - Parse it real good - use a protocol to insure conformity in the parsers
/// * future refactor to use generics so there's only one parser

class MHPParser { /* only used to return the correct class from the ServiceOptions enum */ }

protocol Parseable {
    
}

// FirestoreParser: map the response to the model
class MHPFirestoreParser: MHPParser, Parseable {
    
}

// RealtimeDBParser: map the  response to a model
class MHPRealtimeDBParser: MHPParser, Parseable {
    
}

// AWSParser: map the  response to a model
class MHPAWSParser: MHPParser, Parseable {
    
}


// MARK: - Complete the call
// return the model to the original caller


