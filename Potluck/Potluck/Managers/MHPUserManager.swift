//
//  MHPUserManager.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 4/1/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

enum Result<T, Error> {
    case success(T)
    case error(Error)
}

protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

protocol UserHandler {
    func handleUser()
}

struct MHPUserManager {
    let networkManager = MHPNetworkManager()
    
    func createOrRetrieveUser(completion: @escaping ((Result<MHPUser, DatabaseError> ) -> ())) {
        if let currentUser = Auth.auth().currentUser {
            // retrieve mhpUser from db
            networkManager.retrieve(firUser: currentUser) { (result) in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .error(_):
                    do {
                        try Auth.auth().signOut()
                    } catch let err {
                        print(err)
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                    }
                }
            }
        } else {
            // sign in as anon user
            networkManager.signInAnon { (result) in
                switch result {
                case .success (let firUser):
                    // save anon user to db
                    self.networkManager.save(anonUser:firUser, completion:{ (result) in
                        switch result {
                        case .success(_):
                            // retrieve mhpUser from db
                            self.networkManager.retrieve(firUser:firUser, completion:{ (result) in
                                switch result {
                                case .success(let mhpUser):
                                    completion(.success(mhpUser))
                                default:
                                    completion(.error(DatabaseError.errorRetrievingUserFromDB))
                                }
                            })
                        default:
                            completion(.error(DatabaseError.errorAddingNewUserToDB))
                        }
                    })
                default:
                    completion(.error(DatabaseError.errorRetrievingUserFromDB))
                }
            }
        }
    }
}
