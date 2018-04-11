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
    var mhpUser = MHPUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mhpUser.userState != .registered {
            btnLogInOut.isHidden = true
            if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
                let navController = UINavigationController(rootViewController: signinVC)
                signinVC.mhpUser = mhpUser
                present(navController, animated: true, completion: nil)
            }
        } else {
            setupView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupView() {
        btnLogInOut.isHidden = false
        // populate view with user data
    }
    
    @IBAction func logInOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if let tabs = tabBarController?.viewControllers {
                if tabs.count > 0 {
                    self.tabBarController?.selectedIndex = 0
                    if let homeVC = tabBarController?.childViewControllers[(self.tabBarController?.selectedIndex)!].childViewControllers[0] as? MHPHomeViewController {
                        homeVC.mhpUser = self.mhpUser
                    }
                }
            }
        } catch let signOutError as NSError {
            // handle error
            print("Error signing out: %@", signOutError)
        }
    }
}
