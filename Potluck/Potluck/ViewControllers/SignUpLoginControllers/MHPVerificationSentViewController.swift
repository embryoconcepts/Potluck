//
//  MHPVerificationSentViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/23/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

enum VerificationFlow {
    case EmailVerification
    case ResetPassword
}

class MHPVerificationSentViewController: MHPBaseViewController {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    var email: String?
    var flow: VerificationFlow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let flowState = flow {
            switch flowState {
            case .EmailVerification:
                lblMessage.text = "Please check your email, and use the link we sent to verify your email."
                btnResend.setTitle("Resend Email Verification", for: .normal)
                btnResend.isEnabled = true
                btnResend.isHidden = false;
                break
            case .ResetPassword:
                lblMessage.text = "Please check your email, and use the link to reset your password."
                btnResend.isHidden = true
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func cancelTappped(_ sender: UIBarButtonItem) {
        cancel()
    }
    
    @IBAction func resendTapped(_ sender: Any) {
        
        // resend email verification with email
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        if let tempEmail = email {
            actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/emailVerification/?email=\(tempEmail)")
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            if let user = Auth.auth().currentUser {
                user.sendEmailVerification(completion:{ (error) in
                    if error == nil {
                        self.btnResend.setTitle("Sent!", for: .normal)
                        self.btnResend.isEnabled = false
                        
                        return
                    } else {
                        // handle error
                        print(error?.localizedDescription as Any)
                    }
                })
            }
        }
    }
}
