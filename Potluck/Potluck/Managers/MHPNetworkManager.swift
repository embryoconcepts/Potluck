//
//  MHPNetworkManager.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 4/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

struct MHPNetworkManager {
    let db = Firestore.firestore()
    let dataManager = MHPDataManager()
    let request = MHPRequestHandler()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    
    // MARK: - User Signup/Login Methods
    
    func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        Auth.auth().signInAnonymously() { (user, error) in
            if error == nil {
                if let returnedUser = user {
                    let ref: DocumentReference = self.db.collection("users").document(returnedUser.uid)
                    let dataSet = self.dataManager.buildDataSet(firUserEmail: returnedUser.email, mhpUser: nil, firstName: nil, lastName: nil, state: .anonymous)
                    ref.setData(dataSet, options: SetOptions.merge()) { (error) in
                        if let error = error {
                            print("Error adding document: \(error)")
                            completion(.failure(error))
                        } else {
                            print("Anon user added with ID: \(ref.documentID)")
                            // retrieve mhpUser from db
                            self.request.retrieveUser(completion: { (result) in
                                switch result {
                                case .success(let mhpUser):
                                    completion(.success(mhpUser))
                                default:
                                    completion(.failure(error!))
                                }
                            })
                        }
                        
                    }
                }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    
    // MARK: - Update User Methods
    
    func linkUsers(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        // link newly created user to anon user in Firestore
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with: credential, completion: { (user, error) in
                if error == nil {
                    self.request.verifyEmail { (result) in
                        switch result {
                        case .success:
                            return
                        case .failure:
                            completion(.failure(error!))
                        }
                    }
                    // save updated mhpUser info to DB
                    self.request.updateUserState(mhpUser: mhpUser, state: .unverified, completion: { (result) in
                        switch result {
                        case .success(_):
                            // retrieve mhpUser from db
                            self.request.retrieveUser(completion: { (result) in
                                switch result {
                                case .success(let mhpUser):
                                    completion(.success(mhpUser))
                                default:
                                    completion(.failure(error!))
                                }
                            })
                        default:
                            completion(.failure(error!))
                        }
                    })
                } else {
                    completion(.failure(error!))
                }
            })
        }
    }
}
