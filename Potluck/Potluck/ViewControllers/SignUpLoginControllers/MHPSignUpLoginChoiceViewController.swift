//
//  MHPSignUpLoginChoiceViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

protocol LoginViewControllerDelegate:class {
    func didLoginSuccessfully(mhpUser: MHPUser)
}

class MHPSignUpLoginChoiceViewController: MHPBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var mhpUser: MHPUser?
    var firUser: User?
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTappped(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let state = mhpUser?.userState {
            switch state {
            case .registered:
                dismiss(animated: true, completion: nil)
            case .verified:
                if let personalVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "PersonalInfoVC") as? MHPPersonalInfoViewController {
                    personalVC.mhpUser = self.mhpUser!
                    self.present(personalVC, animated: true, completion: nil)
                }
            case .unverified:
                sendVerificationEmail(forUser:Auth.auth().currentUser)
            case .unknown:
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func cancelTappped(_ sender: UIBarButtonItem) {
        close()
    }
    
    fileprivate func close() {
        // return user to original flow (ie, View Event or Create Event)
        // TODO: double check after Event flows built
        let tabBarIndex = (self.presentingViewController as! UITabBarController).selectedIndex
        switch tabBarIndex {
        case 0:
            let homeVC = MHPHomeViewController()
            homeVC.mhpUser = self.mhpUser!
        case 1:
            return
        case 2:
            if let registered = self.mhpUser?.isRegistered {
                if registered {
                    let profileVC = MHPProfileViewController()
                    profileVC.mhpUser = self.mhpUser!
                } else {
                    let homeVC = MHPHomeViewController()
                    homeVC.mhpUser = self.mhpUser!
                }
            }
        case 3:
                if self.mhpUser?.userState == .registered {
                    // FIXME: not passing the user back correctly
                    let settingsVC = MHPSettingsViewController()
                    settingsVC.mhpUser = self.mhpUser!
                } else {
                    let homeVC = MHPHomeViewController()
                    homeVC.mhpUser = self.mhpUser!
                }
        default:
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if txtEmail.text == "" || txtPassword.text == "" {
            if txtEmail.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            } else if txtPassword.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        } else {
            if let email = txtEmail.text, let password = txtPassword.text {
                // TODO: if anon, link any event creation or whatever with db user
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error == nil {
                        if let fUser = user {
                            UserManager().retrieveMHPUserWith(firUser: fUser) { result in
                                switch result {
                                case let .success(retrievedUser):
                                    self.mhpUser = retrievedUser as? MHPUser
                                    self.mhpUser?.userState = .registered
                                    self.close()
                                case .error(_):
                                    
                                    print(DatabaseError.errorRetrievingUserFromDB)
                                }
                            }
                        }
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        // validate the fields, check if email is already in use, sanitize
        if txtEmail.text == "" || txtPassword.text == "" {
            if txtEmail.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            } else if txtPassword.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        } else {
            if let email = txtEmail.text, let password = txtPassword.text {
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                Auth.auth().currentUser?.link(with: credential, completion:{ (user, error) in
                    if error == nil {
                        self.sendVerificationEmail(forUser: user)
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                })
                
//                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                }
            }
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Password Reset", message: "Please enter your email address:", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler:{ textField in
            textField.placeholder = "Input your email here..."
        })
        
        alert.addAction(UIAlertAction(title:"OK", style:.default, handler:{ action in
            if let email = alert.textFields?.first?.text {
                self.sendResetPasswordEmail(forEmail: email)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        // set up facebook login
    }
    
    @IBAction func googleTapped(_ sender: Any) {
        // set up google login
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
        default:
            txtPassword.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange = true
        if textFieldToChange == txtEmail {
            let characterSetNotAllowed = CharacterSet.init(charactersIn: "#!$%&^* ")
            if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
                shouldChange = false
            } else {
                shouldChange = true
            }
        }
        
        return shouldChange
    }
    
    
    // MARK: - Dynamic Links
    
    func sendVerificationEmail(forUser currentUser: User?) {
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        if let user = currentUser, let email = user.email {
            actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/emailVerification/?email=\(email)")
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            user.sendEmailVerification(completion:{ (error) in
                if error == nil {
                    if let verificationVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC") as? MHPVerificationSentViewController {
                        verificationVC.flow = VerificationFlow.EmailVerification
                        verificationVC.email = email
                        self.present(verificationVC, animated: true, completion: nil)
                    }
                    
                    return
                } else {
                    // handle error
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }
    
    func sendResetPasswordEmail(forEmail email: String) {        
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "https://tza3e.app.goo.gl/resetPassword/?email=\(email)")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                if let verificationVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC") as? MHPVerificationSentViewController {
                    verificationVC.flow = VerificationFlow.ResetPassword
                    verificationVC.email = email
                    self.present(verificationVC, animated: true, completion: nil)
                }
                
                return
            } else {
                // handle error
                print(error?.localizedDescription as Any)
            }
        }
    }
}
