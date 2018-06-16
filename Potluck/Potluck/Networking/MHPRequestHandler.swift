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
    
    func router() -> MHPServiceRouter {
        switch self {
        case .FirebaseFirestore:
            return MHPFirebaseFirestoreServiceRouter()
        case .FirebaseRealtimeDatabase:
            return MHPFirebaseRealtimeDBServiceRouter()
        }
    }
    
    func parser() -> MHPParser {
        switch self {
        case .FirebaseFirestore:
            return MHPFirestoreParser()
        case .FirebaseRealtimeDatabase:
            return MHPRealtimeDBParser()
        }
    }
}


// MARK: - Build the request for the set service, pass request to the correct ServiceRouter

struct MHPRequestHandler {
    private let service: ServiceOption
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }
    
    func sendVerificationEmail(forUser currentUser: User?, completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router().sendVerificationEmail(forUser: currentUser) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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


// MARK: - Send a request to the correct service

class MHPServiceRouter {
    func sendVerificationEmail(forUser currentUser: User?, completion: @escaping (Result<Bool, Error> ) -> ()) {}
    func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {}
}

protocol Routeable {
    
}

// FIXME: would prefer to use stucts and protocols here, but enum func return seems to force class/subclass
class MHPFirebaseFirestoreServiceRouter: MHPServiceRouter, Routeable {
    let db = Firestore.firestore()
    let dataManager = MHPDataManager()
    
    override init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    override func sendVerificationEmail(forUser currentUser: User?, completion: @escaping (Result<Bool, Error> ) -> ()) {
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        if let user = currentUser, let email = user.email {
            actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/emailVerification/?email=\(email)")
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            user.sendEmailVerification(completion: { (error) in
                if error == nil {
                    print("verification email sent")
                    completion(.success(true))
                } else {
                    // handle error
                    print("Send Verification email error: \(String(describing: error))")
                    completion(.failure(error!))
                }
            })
        }
    }
    
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

class MHPFirebaseRealtimeDBServiceRouter: MHPServiceRouter, Routeable {
    override func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        
    }
}


// MARK: - Receive the data response from the service, sends it to the correct parser per the service used

struct ResponseHandler {
    private let service: ServiceOption
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }
}


// MARK: - Parse the response as needed for the service specified (future refactor to use generics so there's only one parser)

class MHPParser {

}

protocol Parseable {
    
}

class MHPFirestoreParser: MHPParser, Parseable {
    
}

class MHPRealtimeDBParser: MHPParser, Parseable {
    
}
