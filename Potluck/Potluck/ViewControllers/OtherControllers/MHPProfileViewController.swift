//
//  MHPProfileViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPProfileViewController: UIViewController {
    
    var mhpUser = MHPUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mhpUser.userState != .registered || Auth.auth().currentUser == nil {
            if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
                let navController = UINavigationController(rootViewController: signinVC)
                signinVC.mhpUser = mhpUser
                present(navController, animated: true, completion: nil)
            }
        } else {
            setupUser()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUser() {
        if let firUser = Auth.auth().currentUser {
            firUser.reload(completion:{ (error) in
                if error == nil {
                    // TODO: retrieve user info, or have it passed back in
                    
                } else {
                    // TODO: handle error
                }
            })
        } else {
            
        }
    }
}
