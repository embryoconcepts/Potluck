//
//  MHPPersonalInfoViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPPersonalInfoViewController: MHPBaseViewController, Injectable {
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    typealias T = User
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTappped(_:)))

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
        if let first = txtFirstName.text, let last = txtLastName.text {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(first) \(last)"
            changeRequest?.commitChanges { (error) in
                if error == nil {
                    // TODO: send verification email or text
                } else {
                    print(error!)
                }
            }
        }
    }
    
    
    // MARK: - Injectable Protocol
    
    func inject(_ data: User) {
        user = data
    }
    
    func assertDependencies() {
        assert(user != nil)
    }
    
    
}
