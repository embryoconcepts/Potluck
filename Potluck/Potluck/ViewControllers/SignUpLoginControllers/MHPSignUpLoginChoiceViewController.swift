//
//  MHPSignUpLoginChoiceViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

protocol HomeUserDelegate:class {
    func updateUser(mhpUser: MHPUser)
}

protocol ProfileUserDelegate:class {
    func updateUser(mhpUser: MHPUser)
}

protocol SettingsUserDelegate:class {
    func updateUser(mhpUser: MHPUser)
}

class MHPSignUpLoginChoiceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var txtAlert: UILabel!
    @IBOutlet weak var btnAlert: UIButton!
    
    var mhpUser: MHPUser?
    var firUser: User?
    lazy var networkManager: MHPNetworkManager = {
        return MHPNetworkManager()
    }()
    weak var settingsDelegate: SettingsUserDelegate?
    weak var profileDelegate: ProfileUserDelegate?
    weak var homeUserDelegate: HomeUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelTappped(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleUser()
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
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = validateEmail(email: txtEmail.text), let pass = validatePassword(password: txtPassword.text) {
            loginUser(email: email, password: pass)
            self.switchOnUserState()
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        if let txtEmail = validateEmail(email: txtEmail.text), let pass = validatePassword(password: txtPassword.text), let mhpUser = self.mhpUser {
            // FIXME: fix issue when a current user exists, but is not verified, and user attempts to sign up as a new user
            networkManager.linkUsers(email: txtEmail, password: pass, mhpUser: mhpUser) { (result) in
                switch result {
                case .success(let user):
                    self.mhpUser = user
                    self.switchOnUserState()
                case .error(let error):
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
            // handle error
            if let email = alert.textFields?.first?.text {
                self.networkManager.sendResetPasswordEmail(forEmail:email, completion:{ (result) in
                    switch result {
                    case .success:
                        print("password reset email sent")
                    case .error:
                        print("password reset email error")
                    }
                })
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func alertTapped(_ sender: Any) {
        if let fUser = Auth.auth().currentUser {
            networkManager.sendVerificationEmail(forUser: fUser) { (result) in
                // TODO: handle result
            }
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        // set up facebook login
    }
    
    @IBAction func googleTapped(_ sender: Any) {
        // set up google login
    }
    
    
    // MARK: - Private methods
    
    fileprivate func switchOnUserState()  {
        if let state = mhpUser?.userState {
            switch state {
            case .registered:
                viewAlert.isHidden = true
                dismiss(animated: true, completion: nil)
            case .verified:
                viewAlert.isHidden = true
                if let personalVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "PersonalInfoVC") as? MHPPersonalInfoViewController {
                    personalVC.mhpUser = self.mhpUser!
                    navigationController?.present(personalVC, animated:true, completion:nil)
                }
            case .unverified:
                viewAlert.isHidden = false;
                txtAlert.text = "Verification email has been sent. Please use the link in the email to verify. Tap here to resend email."
                btnAlert.isEnabled = true
            case .anonymous:
                viewAlert.isHidden = true
                return
            }
        }
    }
    
    fileprivate func close() {
        // double check after Event flows built
        guard let tabBarCon = self.presentingViewController as? UITabBarController else { return }
        if let homeVC = tabBarCon.childViewControllers[0].childViewControllers[0] as? MHPHomeViewController {
            homeVC.inject(self.mhpUser!)
        }
        
        if self.mhpUser?.userState == .registered {
            let tabBarIndex = (self.presentingViewController as! UITabBarController).selectedIndex
            switch tabBarIndex {
            case 0:
                homeUserDelegate?.updateUser(mhpUser: self.mhpUser!)
            case 1:
                return
            case 2:
                profileDelegate?.updateUser(mhpUser: self.mhpUser!)
            case 3:
                settingsDelegate?.updateUser(mhpUser: self.mhpUser!)
            default:
                return
            }
        } else {
            if let tabs = tabBarCon.viewControllers {
                if tabs.count > 0 {
                    tabBarCon.selectedIndex = 0
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func validateEmail(email: String?) -> String? {
        guard let trimmedText = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options:[],
                                              range:range)
        
        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true {
            return trimmedText
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return nil
        }
    }
    
    fileprivate func validatePassword(password: String?) -> String? {
        // TODO: improve validation
        if password != "" || password != nil {
            return password!
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return nil
        }
    }
    
    
    // MARK: - Network methods to be extracted to manager
    
    func loginUser(email: String, password: String) {
        // TODO: extract to network manager, return error?

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                MHPNetworkManager().retrieve(firUser:user!, completion:{ (result) in
                    
                    switch result {
                    case let .success(retrievedUser):
                        self.mhpUser = retrievedUser
                        self.close()
                    case .error(_):
                        print(DatabaseError.errorRetrievingUserFromDB)
                    }
                })
                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
        // TODO: add in place password validation
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
    
}

extension MHPSignUpLoginChoiceViewController:Injectable {
    typealias T = MHPUser
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
}

extension MHPSignUpLoginChoiceViewController:UserHandler {
    func handleUser() {
        MHPUserManager().createOrRetrieveUser { (result) in
            switch result {
            case .success(let user):
                self.mhpUser = user
                self.assertDependencies()
                self.switchOnUserState()
            case .error(_):
                print(DatabaseError.errorRetrievingUserFromDB)
            }
        }
    }
}
