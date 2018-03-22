//
//  MHPSignUpLoginChoiceViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPSignUpLoginChoiceViewController: MHPBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    var fireUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTappped(_:)))

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
        cancel()
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
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error == nil {
                        print("You have successfully signed up")
                        self.fireUser = user
                        self.dismiss(animated: true, completion: nil)
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
        // TODO: validate the fields, check if email is already in use, sanitize
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
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    // TODO: set up verification email
                    if error == nil {
                        print("You have successfully signed up")
                        self.fireUser = user
                        if let personalInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoVC") as? MHPPersonalInfoViewController {
                            if let tempUser = user {
                                personalInfoVC.inject(tempUser)
                            }
                            self.navigationController?.pushViewController(personalInfoVC, animated:true)
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
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        // TODO: set up password reset
//        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
//        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        // TODO: set up facebook login
    }
    
    @IBAction func googleTapped(_ sender: Any) {
        // TODO: set up google login
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
            let characterSetNotAllowed = CharacterSet.init(charactersIn: "#!$%&^*")
            if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
                shouldChange = false
            } else {
                shouldChange = true
            }
        }
        
        return shouldChange
    }
}
