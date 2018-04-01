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

enum Result<T> {
    case success(Any)
    case error(Error)
}

enum DatabaseError: Error {
    case errorAddingNewUserToDB
    case errorRetrievingUserFromDB
}

struct UserManager {
    
    let db = Firestore.firestore()
    

    func login(user: MHPUser) {
        
    }
    
    func logout(user: MHPUser) {
        
    }
    
    func linkUsers(firUser: User, withMHPUser: MHPUser) {
        
    }
    
    func saveFirUserToMHPUser(firUser: User, firstName: String, lastName: String, completion: @escaping ((Result<Bool> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        ref.setData([
            "userFirstName":firstName,
            "userLastName":lastName,
            "userEmail":Auth.auth().currentUser?.email ?? "",
            "userPhone":"",
            "userProfileURL":"",
            "userFacebookID":"",
            "isRegistered":true,
            "userEventListID":"",
            "notificationPermissions":false,
            "notificationPreferences":false,
            "locationPermissions":false,
            "facebookPermissions":false
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
    
    func retrieveMHPUserWith(firUser: User, completion: @escaping ((Result<MHPUser> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        var user = MHPUser()
        ref.getDocument(completion:{ (document, error) in
            if let document = document {
                user.userID = document.documentID
                user.userFirstName = document.data()["userFirstName"] as? String ?? ""
                user.userLastName = document.data()["userLastName"] as? String ?? ""
                user.userEmail = document.data()["userEmail"] as? String ?? ""
                user.userPhone = document.data()["userPhone"] as? String ?? ""
                user.userProfileURL = URL(string: document.data()["userProfileURL"] as? String ?? "")
                user.userFacebookID = document.data()["userFacebookID"] as? String ?? ""
                user.isRegistered = document.data()["isRegistered"] as? Bool ?? true
                user.userEventListID = document.data()["userEventListID"] as? String ?? ""
                user.notificationPermissions = document.data()["notificationPermissions"] as? Bool ?? false
                user.notificationPreferences = document.data()["notificationPreferences"] as? Bool ?? false
                user.locationPermissions = document.data()["locationPermissions"] as? Bool ?? false
                user.facebookPermissions = document.data()["facebookPermissions"] as? Bool ?? false
                user.userState = .registered
                completion(.success(user))
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
        
    }
}
