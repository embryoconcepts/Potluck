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
    
    func login(email: String, password: String) {
        
    }
    
    func logout(user: MHPUser) {
        
    }
    
    func linkUsers(firUser: User, withMHPUser: MHPUser) {
        
    }
    
    func setupUser(completion: @escaping ((MHPUser) -> ())) {
        var mhpUser = MHPUser()
        if let firUser = Auth.auth().currentUser {
            if firUser.isAnonymous {
                anonSetup(firUser: firUser) { (anonUser) in
                    completion(anonUser)
                }
            } else if firUser.isEmailVerified {
                mhpUser.userState = .verified
                self.retrieveMHPUserWith(firUser: firUser) { (result) in
                    switch result {
                    case let .success(user):
                        mhpUser = (user as! MHPUser)
                        mhpUser.userState = .registered
                        completion(mhpUser)
                    case .error(_):
                        // user has not completed registration
                        print(DatabaseError.errorRetrievingUserFromDB)
                        completion(mhpUser)
                    }
                }
            } else {
                // user has not verified email
                mhpUser.userState = .unverified
                completion(mhpUser)
            }
        } else {
            Auth.auth().signInAnonymously() { (user, error) in
                self.anonSetup(firUser: user!) { (anonUser) in
                    completion(anonUser)
                }
            }
        }
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
    
    func saveAnonFirUserToMHPUser(firUser: User, completion: @escaping ((Result<Bool> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        ref.setData([
            "userFirstName":"",
            "userLastName":"",
            "userEmail":"",
            "userPhone":"",
            "userProfileURL":"",
            "userFacebookID":"",
            "isRegistered":false,
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
                completion(.success(user))
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func anonSetup(firUser: User, completion: @escaping ((MHPUser) -> ())) {
        var mhpUser = MHPUser()
        self.saveAnonFirUserToMHPUser(firUser:firUser, completion:{ (result) in
            switch result {
            case .success(_):
                self.retrieveMHPUserWith(firUser: firUser) { (result) in
                    mhpUser.userState = .unknown
                    switch result {
                    case let .success(user):
                        mhpUser = (user as! MHPUser)
                        completion(mhpUser)
                    case .error(_):
                        print(DatabaseError.errorRetrievingUserFromDB)
                        completion(mhpUser)
                    }
                }
            case .error(_):
                print(DatabaseError.errorRetrievingUserFromDB)
            }
        })
    }
}
