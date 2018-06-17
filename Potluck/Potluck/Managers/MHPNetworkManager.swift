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
    let requestHandler = MHPRequestHandler()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    
    // MARK: - Local Firebase methods
    
    func retrieveCurrentLocalFirebaseUser() -> User? {
        return Auth.auth().currentUser
    }
    
    
    // MARK: - User Signup/Login Methods
    
    func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                MHPNetworkManager().retrieve(firUser: user!, completion: { (result) in
                    switch result {
                    case let .success(retrievedUser):
                        completion(.success(retrievedUser))
                    case .failure(_):
                        completion(.failure(error!))
                    }
                })
            } else {
                completion(.failure(error!))
            }
        }
    }
    
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
                            self.retrieve(firUser: returnedUser, completion: { (result) in
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
    
    func updateUserForState(firUser: User, mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in updateUserForState: \(String(describing: error))")
            }
        }
        
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUserEmail: firUser.email, mhpUser: mhpUser, firstName: nil, lastName: nil, state: state)
        ref.setData(dataSet, options: SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.failure(error))
            } else {
                print("User updated with document ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
        
    }
    
    func linkUsers(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        // link newly created user to anon user in Firestore
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let currentUser = retrieveCurrentLocalFirebaseUser() {
            currentUser.link(with: credential, completion: { (user, error) in
                if error == nil {
                    self.requestHandler.sendVerificationEmail(forUser: user, completion: { (result) in
                        switch result {
                        case .success:
                            return
                        case .failure:
                            completion(.failure(error!))
                        }
                        
                    })
                    // save updated mhpUser info to DB
                    self.updateUserForState(firUser: user!, mhpUser: mhpUser, state: .unverified, completion: { (result) in
                        switch result {
                        case .success(_):
                            // retrieve mhpUser from db
                            self.retrieve(firUser: user!, completion: { (result) in
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
    
    
    // MARK: - User Convenience Methods
    
    /**
     Retrieves a MHPUser from the database for the UID of the Firebase User
     - parameter firUser: Firebase User object
     - parameter completion: Result object containing MHPUser or DatabaseError
     */
    func retrieve(firUser: User, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in retrieve: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        ref.getDocument(completion: { (document, error) in
            if let document = document, let data = document.data() {
                let mhpUser = self.dataManager.parseResponseToUser(document: document, data: data)
                if firUser.isEmailVerified && (mhpUser.userState == .anonymous || mhpUser.userState == .unverified) {
                    self.updateUserForState(firUser: firUser, mhpUser: mhpUser, state: .verified, completion: { (result) in
                        switch result {
                        case .success(_):
                            return
                        case .failure (let error):
                            completion(.failure(error))
                        }
                    })
                }
                completion(.success(mhpUser))
            } else {
                completion(.failure(error!))
            }
        })
    }
}
