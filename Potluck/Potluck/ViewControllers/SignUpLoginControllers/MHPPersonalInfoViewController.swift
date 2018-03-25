//
//  MHPPersonalInfoViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MHPPersonalInfoViewController: MHPBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         db = Firestore.firestore()
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
                let displayName = "\(first) \(last)"
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                changeRequest?.commitChanges { (error) in
                    if error == nil {
                        let ref: DocumentReference = self.db.collection("users").document((Auth.auth().currentUser?.uid)!)
                        ref.setData([
                            "userFirstName":first,
                            "userLastName":last,
                            "userEmail":Auth.auth().currentUser?.email ?? "",
                            "userPhone":"",
                            "userProfileURL":"",
                            "userFacebookID":"",
                            "isRegistered":true,
                            "userEventListID":"",
                            "notificationPermissions":false,
                            "notificationPreferences":false,
                            "locationPermissions":false,
                            "facebookPermissions":false
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(ref.documentID)")
                                if let congratsVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationScreenVC") as? MHPConfirmationScreenViewController {
                                    self.present(congratsVC, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        // TODO: handle error
                        print(error!.localizedDescription)
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
    
    
}
