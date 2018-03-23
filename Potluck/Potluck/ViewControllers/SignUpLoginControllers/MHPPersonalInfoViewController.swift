//
//  MHPPersonalInfoViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPPersonalInfoViewController: MHPBaseViewController {
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTappped(_:)))
        user = Auth.auth().currentUser
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
    
    @IBAction func cancelTappped(_ sender: UIBarButtonItem) {
        returnToSignUpRoot()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        // TODO: create a user object in the database and populate
        if let first = txtFirstName.text, let last = txtLastName.text {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(first) \(last)"
            changeRequest?.commitChanges { (error) in
                if error == nil {
                    // TODO: check that user is verified, send to congrats screen
                } else {
                    // TODO: handle error
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
}
