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

    var mhpUser: MHPUser?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = mhpUser {
            if user.userState != .registered {
                if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
                    let navController = UINavigationController(rootViewController: signinVC)
                    signinVC.inject(user)
                    signinVC.profileDelegate = self
                    present(navController, animated: true, completion: nil)
                }
            } else {
                setupView()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setupView() {
        // populate view with user data
    }
}


// MARK: - ProfileUserDelegate

extension MHPProfileViewController: ProfileUserDelegate {
    func updateUser(mhpUser: MHPUser) {
        self.mhpUser = mhpUser
    }

}


// MARK: - InjectableProtocol

extension MHPProfileViewController: Injectable {
    typealias T = MHPUser

    func inject(_ user: T) {
        self.mhpUser = user
    }

    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
}
