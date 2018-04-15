//
//  MHPPersonalInfoViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

class MHPPersonalInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    var mhpUser = MHPUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if txtFirstName.text == "" || txtLastName.text == "" {
            if txtFirstName.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your first name.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            } else if txtLastName.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your last name.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        } else {
            if let first = txtFirstName.text, let last = txtLastName.text {
                guard let currentUser = Auth.auth().currentUser else { return }
                
                MHPNetworkManager().save(registeredUser: currentUser, firstName: first, lastName: last) { result in
                    switch result {
                    case .success(_):
                        MHPNetworkManager().retrieve(user: currentUser) { result in
                            switch result {
                            case let .success(retrievedUser):
                                if let congratsVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationScreenVC") as? MHPConfirmationScreenViewController {
                                    congratsVC.user = retrievedUser 
                                    self.present(congratsVC, animated: true, completion: nil)
                                }
                            case .error(_):
                                print(DatabaseError.errorRetrievingUserFromDB)
                            }
                        }
                    case .error(_):
                        print(DatabaseError.errorAddingNewUserToDB)
                    }
                }
            }
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFirstName:
            txtLastName.becomeFirstResponder()
        default:
            txtLastName.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange = true
        let characterSetNotAllowed = CharacterSet.init(charactersIn: "#!$%&^* ")
        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
            shouldChange = false
        } else {
            shouldChange = true
        }
        
        return shouldChange
    }
    
    func validateText() {
        // TODO: extract validation, give visual cues
        
    }
}
