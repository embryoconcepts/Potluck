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
            if let document = document, let data = document.data() {
                user.userID = document.documentID
                user.userFirstName = data["userFirstName"] as? String ?? ""
                user.userLastName = data["userLastName"] as? String ?? ""
                user.userEmail = data["userEmail"] as? String ?? ""
                user.userPhone = data["userPhone"] as? String ?? ""
                user.userProfileURL = URL(string: data["userProfileURL"] as? String ?? "")
                user.userFacebookID = data["userFacebookID"] as? String ?? ""
                user.isRegistered = data["isRegistered"] as? Bool ?? true
                user.userEventListID = data["userEventListID"] as? String ?? ""
                user.notificationPermissions = data["notificationPermissions"] as? Bool ?? false
                user.notificationPreferences = data["notificationPreferences"] as? Bool ?? false
                user.locationPermissions = data["locationPermissions"] as? Bool ?? false
                user.facebookPermissions = data["facebookPermissions"] as? Bool ?? false
                user.userState = .registered
                completion(.success(user))
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
        
    }
}
