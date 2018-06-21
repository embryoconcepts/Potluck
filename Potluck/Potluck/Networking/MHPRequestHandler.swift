//
//  MHPRequestHandler.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/14/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import UIKit

/// Builds the request for the selected service, passes the request to the correct ServiceRouter
/// ServiceOption should be set in AppDelegate, default value can be overridden for testing
struct MHPRequestHandler {
    private let service: ServiceOption
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }
    
    func getUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.getUser { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.loginUser(email: email, password: password) { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.signInAnon { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.registerUser(email: email, password: password, mhpUser: mhpUser) { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func linkUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.registerUser(email: email, password: password, mhpUser: mhpUser) { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieveUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.retrieveUser { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserState(mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router.updateUserState(mhpUser: mhpUser, state: state) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyEmail(completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router.sendVerificationEmail { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resetPassword(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router.sendResetPasswordEmail(forEmail: email) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
