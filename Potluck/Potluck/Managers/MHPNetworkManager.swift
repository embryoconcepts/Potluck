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

struct NetworkManager {
    let db = Firestore.firestore()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func save(unknownUser: User, completion: @escaping ((Result<Bool, DatabaseError> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(unknownUser.uid)
        ref.setData([
            "userState":"unknown"
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func save(unverifiedUser: User, completion: @escaping ((Result<Bool, DatabaseError> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(unverifiedUser.uid)
        ref.setData([
            "userEmail":unverifiedUser.email ?? "",
            "userState":"unverified"
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func save(verifiedUser: User, completion: @escaping ((Result<Bool, DatabaseError> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(verifiedUser.uid)
        ref.setData([
            "userEmail":verifiedUser.email ?? "",
            "userState":"verified"
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func save(registeredUser: User, firstName: String, lastName: String, completion: @escaping ((Result<Bool, DatabaseError> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(registeredUser.uid)
        ref.setData([
            "userFirstName":firstName,
            "userLastName":lastName,
            "userEmail":registeredUser.email ?? "",
            "userState":"registered"
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Document added with ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
    }
    
    func update(registeredUser: User, mhpUser: MHPUser, completion: @escaping ((Result<Bool, DatabaseError> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(registeredUser.uid)
        let dataSet = buildDataSet(firUser: registeredUser, mhpUser: mhpUser, firstName: nil, lastName: nil, state: "registered")
        ref.setData(dataSet, options: SetOptions.merge()) { (error) in
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
    func retrieve(user: User, completion: @escaping ((Result<MHPUser, DatabaseError> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(user.uid)
        ref.getDocument(completion:{ (document, error) in
            if let document = document, let data = document.data() {
                let user = DataManager().parseResponseToUser(document: document, data: data)
                completion(.success(user))
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
    }
    
    func buildDataSet(firUser: User, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: String) -> [String: Any] {
        var userDict = [String: Any]()
        userDict["userState"] = state
        
        if let mu = mhpUser {
            userDict["userFirstName"] = mu.userFirstName ?? ""
            userDict["userFirstName"] = mu.userFirstName ?? ""
            userDict["userLastName"] = mu.userLastName ?? ""
            userDict["userEmail"] = mu.userEmail ?? firUser.email ?? ""
            userDict["userPhone"] = mu.userPhone ?? ""
            userDict["userProfileURL"] = mu.userProfileURL ?? ""
            userDict["userFacebookID"] = mu.userFacebookID ?? ""
            userDict["userEventListID"] = mu.userEventListID ?? ""
            userDict["notificationPermissions"] = mu.notificationPermissions ?? false
            userDict["notificationPreferences"] = mu.notificationPreferences ?? false
            userDict["locationPermissions"] = mu.locationPermissions ?? false
            userDict["facebookPermissions"] = mu.facebookPermissions ?? false
        } else if let fn = firstName, let ln = lastName {
            userDict["userFirstName"] = fn
            userDict["userLastName"] = ln
        }
        
        return userDict
    }
    
}
