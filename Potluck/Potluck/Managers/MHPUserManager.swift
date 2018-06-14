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
    case failure(Error)
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
    
    func createOrRetrieveUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        if let currentUser = networkManager.retrieveCurrentLocalFirebaseUser() {
            networkManager.retrieve(firUser: currentUser, completion: { (result) in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    do {
                        try Auth.auth().signOut()
                    } catch let err {
                        print("create or retreive try/catch error: \(err)")
                    }
                    completion(.failure(error))
                }
            })
        } else {
            networkManager.signInAnon { (result) in
                switch result {
                case .success (let mhpUser):
                    completion(.success(mhpUser))
                case .failure (let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
