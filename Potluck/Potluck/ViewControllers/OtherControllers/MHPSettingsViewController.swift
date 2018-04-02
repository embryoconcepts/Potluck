//
//  MHPSettingsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPSettingsViewController: MHPBaseViewController {

    @IBOutlet weak var btnLogInOut: UIButton!
    var mhpUser: MHPUser?
    var handle: AuthStateDidChangeListenerHandle?
    var isLoggedIn = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = Auth.auth().currentUser {
            isLoggedIn = true
        } else {
//            if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
//                let navController = UINavigationController(rootViewController: signinVC)
//                present(navController, animated: true, completion: nil)
//            }
        }
        
        // Listen for user login state
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = Auth.auth().currentUser {
                self.isLoggedIn = true
            } else {
                self.isLoggedIn = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func cancelTappped(_ sender: UIBarButtonItem) {
        returnToSignUpRoot()
    }
    
    @IBAction func logInOutTapped(_ sender: Any) {
        if isLoggedIn {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                // TODO: handle error
                print("Error signing out: %@", signOutError)
            }
        }
        isLoggedIn = !isLoggedIn
    }
    
}
