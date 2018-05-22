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
    
    func signInAnon(completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        Auth.auth().signInAnonymously() { (user, error) in
            if error == nil {
                if let returnedUser = user {
                    self.saveAnonUser(firUser:returnedUser, completion:{ (result) in
                        switch result {
                        case .success(let mhpUser):
                            completion(.success(mhpUser))
                        default:
                            completion(.error(DatabaseError.errorAddingNewUserToDB))
                        }
                    })
                }
            } else {
                completion(.error(DatabaseError.errorAddingNewUserToDB))
                
            }
        }
    }
    
    func saveAnonUser(firUser: User, completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in save anon: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: firUser, mhpUser: nil, firstName: nil, lastName: nil, state: .anonymous)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Anon user added with ID: \(ref.documentID)")
                // retrieve mhpUser from db
                self.retrieve(firUser:firUser, completion:{ (result) in
                    switch result {
                    case .success(let mhpUser):
                        completion(.success(mhpUser))
                    default:
                        completion(.error(DatabaseError.errorRetrievingUserFromDB))
                    }
                })
            }
        }
    }
    
    func saveUnverifiedUser(firUser: User, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in save unverified: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: firUser, mhpUser: nil, firstName: nil, lastName: nil, state: .unverified)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Unverified user updated with document ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
        
    }
    
    func saveVerifiedUser(firUser: User, verifiedUser: MHPUser, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in save verified: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: firUser, mhpUser: verifiedUser, firstName: nil, lastName: nil, state: .verified)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Verified user updated with document ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
        
    }
    
    func saveRegisteredUser(firUser: User, firstName: String, lastName: String, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in save registered: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: firUser, mhpUser: nil, firstName: firstName, lastName: lastName, state: .registered)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("Registered user updated with document ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
        
    }
    
    func update(firUser: User, mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, DatabaseError> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in update user: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        let dataSet = dataManager.buildDataSet(firUser: firUser, mhpUser: mhpUser, firstName: nil, lastName: nil, state: state)
        ref.setData(dataSet, options:SetOptions.merge()) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.error(DatabaseError.errorAddingNewUserToDB))
            } else {
                print("User updated with document ID: \(ref.documentID)")
                completion(.success(true))
            }
        }
        
    }
    
    fileprivate func updateVerifiedUser(mhpUser: MHPUser, completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        if let firUser = Auth.auth().currentUser {
            firUser.reload { (error) in
                if error != nil {
                    print("User reload error in update verified: \(String(describing: error))")
                }
                self.saveVerifiedUser(firUser:firUser, verifiedUser:mhpUser, completion:{ (result) in
                    switch result {
                    case .success(_):
                        // retrieve mhpUser from db
                        self.retrieve(firUser:firUser, completion:{ (result) in
                            switch result {
                            case .success(let mhpUser):
                                completion(.success(mhpUser))
                            default:
                                completion(.error(DatabaseError.errorRetrievingUserFromDB))
                            }
                        })
                    default:
                        completion(.error(DatabaseError.errorAddingNewUserToDB))
                    }
                })
            }
        }
    }
    
    /**
     Retrieves a MHPUser from the database for the UID of the Firebase User
     - parameter user: Firebase User object
     - parameter completion: MHPUser object or Database Error
     */
    func retrieve(firUser: User, completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        firUser.reload { (error) in
            if error != nil {
                print("User reload error in retrieve: \(String(describing: error))")
            }
        }
        let ref: DocumentReference = db.collection("users").document(firUser.uid)
        ref.getDocument(completion:{ (document, error) in
            if let document = document, let data = document.data() {
                let mhpUser = self.dataManager.parseResponseToUser(document: document, data: data)
                if firUser.isEmailVerified && (mhpUser.userState == .anonymous || mhpUser.userState == .unverified) {
                    self.updateVerifiedUser(mhpUser:mhpUser, completion:{ (result) in
                        completion(result)
                    })
                }
                completion(.success(mhpUser))
            } else {
                completion(.error(DatabaseError.errorRetrievingUserFromDB))
            }
        })
        
    }
    
    func signupUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        // link newly created user to anon user in Firestore
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with:credential, completion:{ (user, error) in
                if error == nil {
                    self.sendVerificationEmail(forUser:user, completion:{ (result) in
                        completion(result)
                    })
                    // save updated mhpUser info to DB
                    self.saveUnverifiedUser(firUser:user!, completion:{ (result) in
                        switch result {
                        case .success(_):
                            // retrieve mhpUser from db
                            self.retrieve(firUser:user!, completion:{ (result) in
                                switch result {
                                case .success(let mhpUser):
                                    completion(.success(mhpUser))
                                default:
                                    completion(.error(DatabaseError.errorRetrievingUserFromDB))
                                }
                            })
                        default:
                            completion(.error(DatabaseError.errorAddingNewUserToDB))
                        }
                    })
                } else {
                    print(error?.localizedDescription as Any)
                    completion(error as! Result<MHPUser, DatabaseError>)
                }
            })
        }
    }
    
    func sendVerificationEmail(forUser currentUser: User?, completion: @escaping (Result<MHPUser, DatabaseError> ) -> ()) {
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        if let user = currentUser, let email = user.email {
            actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/emailVerification/?email=\(email)")
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            user.sendEmailVerification(completion:{ (error) in
                if error == nil {
                    print("verification email sent")
                    return
                } else {
                    // handle error
                    print(error?.localizedDescription as Any)
                    completion(error as! Result<MHPUser, DatabaseError>)
                }
            })
        }
    }

}
