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
    // swiftlint:disable force_cast
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }

    func getUser(completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.getUser { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.loginUser(email: email, password: password) { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.signInAnon { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func registerUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.registerUser(email: email, password: password, mhpUser: mhpUser) { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func linkUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.registerUser(email: email, password: password, mhpUser: mhpUser) { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func retrieveUserByID(completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.retrieveUserByID { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func retrieveUserByEmail(email: String, completion: @escaping (Result<MHPUser, Error> ) -> Void) {
        service.router.retrieveUserByEmail(email: email) { result in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUserState(mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> Void) {
        service.router.updateUserState(mhpUser: mhpUser, state: state) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func verifyEmail(completion: @escaping (Result<Bool, Error> ) -> Void) {
        service.router.sendVerificationEmail { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func resetPassword(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> Void) {
        service.router.sendResetPasswordEmail(forEmail: email) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getEvent(eventID: String, completion: @escaping (Result<MHPEvent, Error> ) -> Void) {
        service.router.getEvent(eventID: eventID) { result in
            switch result {
            case .success (let event):
                completion(.success(event))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveEvent(event: MHPEvent, completion: @escaping (Result<Bool, Error> ) -> Void) {
        service.router.saveEvent(event: event) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
