//
//  MHPConfirmationScreenViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPConfirmationScreenViewController: UIViewController {

    @IBOutlet weak var lblMessage: UILabel!
    var mhpUser: MHPUser?
    
    
    // MARK: - Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        if let user = mhpUser, let name = user.userFirstName {
            lblMessage.text = "Welcome, \(name)! Your account is all set up and ready to go."
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func closeTapped(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let tabBarController = appDelegate.window?.rootViewController as? UITabBarController,
                let rootVCArray = tabBarController.viewControllers {
                let navCon = rootVCArray[0] as! UINavigationController
                if let homeVC = navCon.topViewController as? MHPHomeViewController, let user = self.mhpUser {
                    homeVC.inject(user)
                    navCon.dismiss(animated: true, completion: nil)
                }
            }
        }
        // TODO: Or? self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

extension MHPConfirmationScreenViewController: Injectable {
    typealias T = MHPUser
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
}
