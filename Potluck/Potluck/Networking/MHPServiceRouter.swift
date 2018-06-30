//
//  MHPServiceRouter.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/18/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

/// Sends a request from the RequestHandler to the selected service
class MHPServiceRouter: Routeable {
    func getUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func registerUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func linkUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func retrieveUserByID(completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func retrieveUserByEmail(email: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func updateUserState(mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> ()) {}
    func sendVerificationEmail(completion: @escaping (Result<Bool, Error> ) -> ()) {}
    func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {}
}

protocol Routeable {
    
}

class MHPFirebaseFirestoreServiceRouter: MHPServiceRouter {
    let db = Firestore.firestore()
    let dataManager = MHPDataManager()
    let actionCodeSettings = ActionCodeSettings.init()
    
    override init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
    }
    
    override func getUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        if Auth.auth().currentUser != nil {
            self.retrieveUserByID { (result) in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    do {
                        try Auth.auth().signOut()
                    } catch let err {
                        print("create or retreive try/catch error: \(err)")
                    }
                    completion(.failure(error))
                }
            }
        } else {
            let mhpUser = MHPUser()
            completion(.success(mhpUser))
        }
    }
    
    override func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                            self.retrieveUserByID{ (result) in
                                switch result {
                                case let .success(retrievedUser):
                                    completion(.success(retrievedUser))
                                case .failure(_):
                                    completion(.failure(error!))
                                }
                            }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    override func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        Auth.auth().signInAnonymously() { (user, error) in
            if error == nil {
                if let returnedUser = user {
                    let ref: DocumentReference = self.db.collection("users").document(returnedUser.uid)
                    let dataSet = self.dataManager.encodeUser(firUserEmail: returnedUser.email, mhpUser: nil, firstName: nil, lastName: nil, state: .anonymous)
                    ref.setData(dataSet, options: SetOptions.merge()) { (error) in
                        if error == nil {
                            print("Anon user added with ID: \(ref.documentID)")
                            // retrieve mhpUser from db
                            self.retrieveUserByID { (result) in
                                switch result {
                                case .success(let mhpUser):
                                    completion(.success(mhpUser))
                                default:
                                    completion(.failure(error!))
                                }
                            }
                        } else {
                            print("Error adding document: \(String(describing: error))")
                            completion(.failure(error!))
                        }
                    }
                }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    override func registerUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.sendVerificationEmail { (result) in
                    switch result {
                    case .success:
                        return
                    case .failure:
                        completion(.failure(error!))
                    }
                }
                // save updated mhpUser info to DB
                self.updateUserState(mhpUser: mhpUser, state: .unverified) { (result) in
                    switch result {
                    case .success(_):
                        // retrieve mhpUser from db
                        self.retrieveUserByID { (result) in
                            switch result {
                            case .success(let mhpUser):
                                completion(.success(mhpUser))
                            default:
                                completion(.failure(error!))
                            }
                        }
                    default:
                        completion(.failure(error!))
                    }
                }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    /// link newly created user to anon user in Firestore
    override func linkUser(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with: credential) { (user, error) in
                if error == nil {
                    self.sendVerificationEmail { (result) in
                        switch result {
                        case .success:
                            return
                        case .failure:
                            completion(.failure(error!))
                        }
                    }
                    // save updated mhpUser info to DB
                    self.updateUserState(mhpUser: mhpUser, state: .unverified) { (result) in
                        switch result {
                        case .success(_):
                            // retrieve mhpUser from db
                            self.retrieveUserByID { (result) in
                                switch result {
                                case .success(let mhpUser):
                                    completion(.success(mhpUser))
                                default:
                                    completion(.failure(error!))
                                }
                            }
                        default:
                            completion(.failure(error!))
                        }
                    }
                } else {
                    completion(.failure(error!))
                }
            }
        }
    }
    
    override func retrieveUserByID(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        if let firUser = Auth.auth().currentUser {
            firUser.reload { (error) in
                if error == nil {
                    let ref: DocumentReference = self.db.collection("users").document(firUser.uid)
                    ref.getDocument { (document, error) in
                        if  let document = document,
                            let data = document.data(),
                            let user = self.dataManager.decodeUser(document: document, data: data) {
                            if firUser.isEmailVerified && (user.userState == .anonymous || user.userState == .unverified) {
                                self.updateUserState(mhpUser: user, state: .verified) { (result) in
                                    switch result {
                                    case .success(_):
                                        return
                                    case .failure (let error):
                                        completion(.failure(error))
                                    }
                                }
                            }
                            completion(.success(user))
                        } else {
                            completion(.failure(error!))
                        }
                    }
                } else {
                    print("User reload error in retrieve: \(String(describing: error))")
                    completion(.failure(error!))
                }
            }
        }
    }
    
    override func retrieveUserByEmail(email: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        let userQuery = db.collection("users").whereField("userEmail", isEqualTo: email)
        userQuery.getDocuments { (snap, error) in
            if error == nil {
                if let documents = snap?.documents {
                    if documents.count > 0 {
                        for document in documents {
                            if let user: MHPUser = MHPDataManager().decodeUser(document: document, data: document.data()) {
                                completion(.success(user))
                            } else {
                                completion(.failure(OtherError.noUserToRetrieve))
                            }
                        }
                    } else {
                        completion(.failure(OtherError.noUserToRetrieve))
                    }
                } else {
                     completion(.failure(OtherError.noUserToRetrieve))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    override func updateUserState(mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> ()) {
        if let firUser = Auth.auth().currentUser {
            firUser.reload { (error) in
                if error == nil {
                    let ref: DocumentReference = self.db.collection("users").document(firUser.uid)
                    let dataSet = self.dataManager.encodeUser(firUserEmail: firUser.email, mhpUser: mhpUser, firstName: nil, lastName: nil, state: state)
                    ref.setData(dataSet, options: SetOptions.merge()) { (error) in
                        if error == nil {
                            print("User updated with document ID: \(ref.documentID)")
                            completion(.success(true))
                        } else {
                            print("Error adding document: \(String(describing: error))")
                            completion(.failure(error!))
                        }
                    }
                } else {
                    print("User reload error in updateUserForState: \(String(describing: error))")
                    completion(.failure(error!))
                }
            }
        }
    }
    
    override func sendVerificationEmail(completion: @escaping (Result<Bool, Error> ) -> ()) {
        if let user = Auth.auth().currentUser, let email = user.email {
            actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/emailVerification/?email=\(email)")
            user.sendEmailVerification { (error) in
                if error == nil {
                    print("verification email sent")
                    completion(.success(true))
                } else {
                    print("Send Verification email error: \(String(describing: error))")
                    completion(.failure(error!))
                }
            }
        }
    }
    
    override func sendResetPasswordEmail(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/resetPassword/?email=\(email)")
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion(.success(true))
            } else {
                completion(.failure(error!))
                print("Reset password error: \(String(describing: error))")
            }
        }
    }
}

class MHPFirebaseRealtimeDBServiceRouter: MHPServiceRouter {
    
}
