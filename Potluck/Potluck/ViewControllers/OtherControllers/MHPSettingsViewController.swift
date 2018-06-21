//
//  MHPSettingsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPSettingsViewController: UIViewController, SettingsUserDelegate {
    
    @IBOutlet weak var btnLogInOut: UIButton!
    var mhpUser: MHPUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mhpUser.userState != .registered {
            btnLogInOut.isHidden = true
            if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
                let navController = UINavigationController(rootViewController: signinVC)
                signinVC.inject(mhpUser)
                signinVC.settingsDelegate = self
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
    
    
    // MARK: Action Handlers
    
    @IBAction func logInOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if let tabs = tabBarController?.viewControllers {
                if tabs.count > 0 {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        } catch let signOutError as NSError {
            let alertController = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - SettingsUserDelegate
    
    func updateUser(mhpUser: MHPUser) {
        self.mhpUser = mhpUser
    }
    
}

extension MHPSettingsViewController: Injectable {
    typealias T = MHPUser
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
}
