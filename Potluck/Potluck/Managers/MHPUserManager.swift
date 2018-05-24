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
    
    func createOrRetrieveUser(completion: @escaping ((Result<MHPUser, Error> ) -> ())) {
        if let currentUser = Auth.auth().currentUser {
            networkManager.retrieve(firUser:currentUser, completion:{ (result) in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .error(let error):
                    do {
                        try Auth.auth().signOut()
                    } catch let err {
                        print("create or retreive try/catch error: \(err)")
                    }
                    completion(.error(error))
                }
            })
        } else {
            networkManager.signInAnon { (result) in
                switch result {
                case .success (let mhpUser):
                    completion(.success(mhpUser))
                case .error (let error):
                    completion(.error(error))
                }
            }
        }
    }
}
