//
//  MHPConfirmationScreenViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPConfirmationScreenViewController: MHPBaseViewController {

    @IBOutlet weak var lblMessage: UILabel!
    var user: MHPUser?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = user?.userFirstName {
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
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion:nil)
            (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
        }

    }
}
