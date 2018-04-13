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

protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

protocol UserInjectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

struct UserManager {
    let db = Firestore.firestore()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func login(email: String, password: String) {
        
    }
    
    func logout(user: MHPUser) {
        
    }
    
    func linkUsers(firUser: User, withMHPUser: MHPUser) {
        
    }
    
    func setupUser(completion: @escaping ((Result<MHPUser> ) -> ())) {
        /*
         when user opens app for the first time, create an anon firUser, and a db entry with a mhpUser, save user state
         when anon user registers, update the db entry with the new information
         when anon user logs in, update the db entry with any new info from the anon user actions
         
         think about how to handle when an anon user follows a link with an event id, then registers.  
         */
        var mhpUser = MHPUser()
        
        // create if needed
        if let firUser = Auth.auth().currentUser {
            if firUser.isAnonymous {
                createAnonUser(firUser: firUser) { (anonUser) in
                    completion(.success(anonUser))
                }
            } else if firUser.isEmailVerified {
                mhpUser.userState = .verified
                
                self.retrieveMHPUserWith(firUser: firUser) { (result) in
                    switch result {
                    case let .success(user):
                        mhpUser = (user as! MHPUser)
                        mhpUser.userState = .registered
                        completion(.success(mhpUser))
                    case .error(_):
                        // user has not completed registration
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                    }
                }
            } else {
                // user has not verified email
                mhpUser.userState = .unverified
                completion(.success(mhpUser))
            }
        } else {
            Auth.auth().signInAnonymously() { (user, error) in
                self.createAnonUser(firUser: user!) { (anonUser) in
                    completion(.success(anonUser))
                }
            }
        }
        
        // retrieve the db user info
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func createAnonUser(firUser: User, completion: @escaping ((Result<MHPUser> ) -> ())) {
        var mhpUser = MHPUser()
        self.saveAnonFirUserToMHPUser(firUser:firUser, completion:{ (result) in
            switch result {
            case .success(_):
                // TODO: split this out from the create function
                self.retrieveMHPUserWith(firUser: firUser) { (result) in
                    mhpUser.userState = .unknown
                    switch result {
                    case let .success(user):
                        mhpUser = (user as! MHPUser)
                        completion(.success(mhpUser))
                    case .error(_):
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                    }
                }
            case .error(_):
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
    }

    
    // MARK: - Data Handling
    
    func saveFirUserToMHPUser(firUser: User, firstName: String, lastName: String, completion: @escaping ((Result<Bool> ) -> ())) {
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        ref.setData([
            "userFirstName":firstName,
            "userLastName":lastName,
            "userEmail":Auth.auth().currentUser?.email ?? "",
            "userPhone":"",
            "userProfileURL":"",
            "userFacebookID":"",
            "userEventListID":"",
            "notificationPermissions":false,
            "notificationPreferences":false,
            "locationPermissions":false,
            "facebookPermissions":false,
            "userState":"registered"
            // TODO: add registration timestamp?
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
            "userEventListID":"",
            "notificationPermissions":false,
            "notificationPreferences":false,
            "locationPermissions":false,
            "facebookPermissions":false,
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
    
    func updateMHPUser() {
        
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
                user.userEventListID = data["userEventListID"] as? String ?? ""
                user.notificationPermissions = data["notificationPermissions"] as? Bool ?? false
                user.notificationPreferences = data["notificationPreferences"] as? Bool ?? false
                user.locationPermissions = data["locationPermissions"] as? Bool ?? false
                user.facebookPermissions = data["facebookPermissions"] as? Bool ?? false
                user.userState = data["userState"] as? UserAuthorizationState ?? .unknown
                
                completion(.success(user))
                // TODO: maybe set user state here
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
    }
    }
