//
//  MHPNetworkManager.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 4/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseError: Error {
    case errorAddingNewUserToDB
    case errorRetrievingUserFromDB
}

struct MHPNetworkManager {
    let db = Firestore.firestore()
    let dataManager = MHPDataManager()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func signInAnon(completion: @escaping (Result<User, Error> ) -> ()) {
        Auth.auth().signInAnonymously() { (user, error) in
            if error == nil {
                if let returnedUser = user {
                    completion(Result.success(returnedUser))
                }
            } else {
                if let returnedError = error {
                    completion(Result.error(returnedError))
                }
            }
        }
    }
    
    func login() {
        
    }
    
    func resetPassword() {
        
    }
    
    func resendVerificationEmail() {
        
    }
    
    func save(unknownUser: User, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        let ref: DocumentReference = db.collection("users").document(unknownUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: unknownUser, mhpUser: nil, firstName: nil, lastName: nil, state: .unknown)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func save(unverifiedUser: User, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        let ref: DocumentReference = db.collection("users").document(unverifiedUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: unverifiedUser, mhpUser: nil, firstName: nil, lastName: nil, state: .unverified)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func save(verifiedUser: User, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        let ref: DocumentReference = db.collection("users").document(verifiedUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: verifiedUser, mhpUser: nil, firstName: nil, lastName: nil, state: .verified)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func save(registeredUser: User, firstName: String, lastName: String, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        let ref: DocumentReference = db.collection("users").document(registeredUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: registeredUser, mhpUser: nil, firstName: firstName, lastName: lastName, state: .registered)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func update(firUser: User, mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: firUser, mhpUser: mhpUser, firstName: nil, lastName: nil, state: state)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
        
    }
    
    /**
     Retrieves a MHPUser from the database for the UID of the Firebase User
     - parameter user: Firebase User object
     - parameter completion: MHPUser object or Database Error
     */
    func retrieve(user: User, completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        let ref: DocumentReference = db.collection("users").document(user.uid)
        ref.getDocument(completion:{ (document, error) in
            if let document = document, let data = document.data() {
                let user = self.dataManager.parseResponseToUser(document: document, data: data)
                completion(.success(user))
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
    }
    
}
