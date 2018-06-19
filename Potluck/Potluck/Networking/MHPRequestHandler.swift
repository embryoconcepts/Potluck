//
//  MHPRequestHandler.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/14/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

/// Builds the request for the selected service, passes the request to the correct ServiceRouter
/// ServiceOption should be set in AppDelegate, default value can be overridden for testing
struct MHPRequestHandler {
    private let service: ServiceOption
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.loginUser(email: email, password: password) { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.signInAnon { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func linkUsers(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.linkUsers(email: email, password: password, mhpUser: mhpUser) { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieveUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        service.router.retrieveUser { (result) in
            switch result {
            case .success (let mhpUser):
                completion(.success(mhpUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserState(mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router.updateUserState(mhpUser: mhpUser, state: state) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyEmail(completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router.sendVerificationEmail { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resetPassword(forEmail email: String, completion: @escaping (Result<Bool, Error> ) -> ()) {
        service.router.sendResetPasswordEmail(forEmail: email) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


/// Sends a request from the RequestHandler to the selected service
class MHPServiceRouter: Routeable {
    func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func linkUsers(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
    func retrieveUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {}
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
    
    override func loginUser(email: String, password: String, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.retrieveUser(completion: { (result) in
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
    
    override func signInAnon(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
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
                            self.retrieveUser(completion: { (result) in
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
    
    override func linkUsers(email: String, password: String, mhpUser: MHPUser, completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        // link newly created user to anon user in Firestore
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with: credential, completion: { (user, error) in
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
                    self.updateUserState(mhpUser: mhpUser, state: .unverified, completion: { (result) in
                        switch result {
                        case .success(_):
                            // retrieve mhpUser from db
                            self.retrieveUser(completion: { (result) in
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
    
    override func retrieveUser(completion: @escaping (Result<MHPUser, Error> ) -> ()) {
        if let firUser = Auth.auth().currentUser {
            firUser.reload { (error) in
                if error != nil {
                    print("User reload error in retrieve: \(String(describing: error))")
                } else {
                    let ref: DocumentReference = self.db.collection("users").document(firUser.uid)
                    ref.getDocument(completion: { (document, error) in
                        if let document = document, let data = document.data() {
                            let mhpUser = self.dataManager.parseResponseToUser(document: document, data: data)
                            if firUser.isEmailVerified && (mhpUser.userState == .anonymous || mhpUser.userState == .unverified) {
                                self.updateUserState(mhpUser: mhpUser, state: .verified, completion: { (result) in
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
        }
    }
    
    override func updateUserState(mhpUser: MHPUser, state: UserAuthorizationState, completion: @escaping (Result<Bool, Error> ) -> ()) {
        if let firUser = Auth.auth().currentUser {
            firUser.reload { (error) in
                if error != nil {
                    print("User reload error in updateUserForState: \(String(describing: error))")
                } else {
                    let ref: DocumentReference = self.db.collection("users").document(firUser.uid)
                    let dataSet = self.dataManager.buildDataSet(firUserEmail: firUser.email, mhpUser: mhpUser, firstName: nil, lastName: nil, state: state)
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
            }
        }
    }
    
    override func sendVerificationEmail(completion: @escaping (Result<Bool, Error> ) -> ()) {
        if let user = Auth.auth().currentUser, let email = user.email {
            actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/emailVerification/?email=\(email)")
            user.sendEmailVerification(completion: { (error) in
                if error == nil {
                    print("verification email sent")
                    completion(.success(true))
                } else {
                    // handle error
                    print("Send Verification email error: \(String(describing: error))")
                    completion(.failure(error!))
                }
            })
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
