//
//  MHPUserManager.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 4/1/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

enum UserAuthorizationState {
    /// not registered or logged in
    case unknown
    /// initial sign up complete, email not verified
    case unverified
    /// email or phone verified, but basic profile details incomplete, not in database
    case verified
    /// verified and confirmed, basic profile complete, added to database
    case registered
}

enum Result<T, Error> {
    case success(T)
    case error(Error)
}

protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

struct UserManager {
    let networkManager = NetworkManager()
        
    func setupUser(completion: @escaping ((Result<MHPUser, DatabaseError> ) -> ())) {
        /*
         when user opens app for the first time, create an anon firUser, and a db entry with a mhpUser, save user state
         when anon user registers, update the db entry with the new information
         when anon user logs in, update the db entry with any new info from the anon user actions
         
         think about how to handle when an anon user follows a link with an event id, then registers.  
         */
        var mhpUser = MHPUser()
        
        // create if needed
        if let firUser = Auth.auth().currentUser {
            if firUser.isAnonymous {
                //                createAnonUser(firUser: firUser) { (anonUser) in
                //                    completion(.success(anonUser))
                //                }
                self.createAnonUser(firUser: firUser) { (result) in
                    switch result {
                    case .success(let anonUser):
                        completion(.success(anonUser))
                    case .error(_):
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                    }
                }
            } else if firUser.isEmailVerified {
                mhpUser.userState = .verified

                networkManager.retrieve(user: firUser) { (result) in
                    switch result {
                    case let .success(user):
                        mhpUser = user
                        mhpUser.userState = .registered
                        completion(.success(mhpUser))
                    case .error(_):
                        // user has not completed registration
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                    }
                }
            } else {
                // user has not verified email
                mhpUser.userState = .unverified
                completion(.success(mhpUser))
            }
        } else {
            Auth.auth().signInAnonymously() { (user, error) in
                self.createAnonUser(firUser: user!) { (result) in
                    switch result {
                    case .success(let anonUser):
                        completion(.success(anonUser))
                    case .error(_):
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                        
                    }
                }
            }
        }
        
        // retrieve the db user info
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func createAnonUser(firUser: User, completion: @escaping ((Result<MHPUser, DatabaseError> ) -> ())) {
        var mhpUser = MHPUser()
        networkManager.save(unknownUser:firUser, completion:{ (result) in
            switch result {
            case .success(_):
                // TODO: split this out from the create function
                self.networkManager.retrieve(user: firUser) { (result) in
                    mhpUser.userState = .unknown
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .error(_):
                        completion(.error(.errorRetrievingUserFromDB))
                    }
                }
            case .error(_):
                completion(.error(.errorRetrievingUserFromDB))
            }
        })
    }
    
}
