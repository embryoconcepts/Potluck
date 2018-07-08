//
//  MHPInviteEmailOrPhoneViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase

protocol EnteredInvitesDelegate {
    func submit(pendingInvites: [MHPInvite])
}

class MHPInviteEmailOrPhoneViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtEmailOrPhone: UITextField!
    @IBOutlet weak var btnAddToList: UIButton!
    
    var mhpUser: MHPUser?
    var tempInvite = MHPInvite(userFirstName: "", userLastName: "", userEmail: "")
    var pendingInvites: [MHPInvite]?
    var enteredInvitesDelegate: EnteredInvitesDelegate?
    lazy var request: MHPRequestHandler = {
        return MHPRequestHandler()
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func addToListTapped(_ sender: Any) {
        if validTextFields() {
            if let email = validateEmail(email: txtEmailOrPhone.text) {
                request.retrieveUserByEmail(email: email) { (result) in
                    switch result {
                    case .success(let user):
                        self.tempInvite.userID = user.userID
                        self.tempInvite.userFirstName = user.userFirstName
                        self.tempInvite.userLastName = user.userLastName
                        self.tempInvite.userEmail = user.userEmail
                        self.tempInvite.userProfileURL = user.userProfileURL
                    case .failure(_):
                        self.tempInvite.userFirstName = self.txtFirst.text
                        self.tempInvite.userLastName = self.txtLast.text
                        self.tempInvite.userEmail = self.txtEmailOrPhone.text
                    }
                    self.pendingInvites!.append(self.tempInvite)
                    self.resetTextFields()
                    DispatchQueue.main.async { [unowned self] in
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let invites = pendingInvites {
            enteredInvitesDelegate?.submit(pendingInvites: invites)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: "Cancel Invites",
                                          message: "Are you sure you want to cancel inviting guests? All invites on this screen will be lost.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func validTextFields() -> Bool {
        var errorMsg = "Required fields:"
        var isValid = true
        
        if txtFirst.text == "" {
            errorMsg += "\nfirst name"
            isValid = false
        }
        
        if txtLast.text == "" {
            errorMsg += "\nlast name"
            isValid = false
        }
        
        if txtEmailOrPhone.text == "" {
            errorMsg += "\nemail"
            isValid = false
        }
        
        if !isValid {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "Missing Details", message: errorMsg, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        return isValid
    }
    
    fileprivate func validateEmail(email: String?) -> String? {
        guard let trimmedText = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1, allMatches.first?.url?.absoluteString.contains("mailto:") == true &&
                trimmedText != mhpUser?.userEmail {
            return trimmedText
        } else {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "Error", message: "Please enter a valid email address.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            return nil
        }
    }
    
    fileprivate func resetTextFields() {
        txtFirst.text = ""
        txtLast.text = ""
        txtEmailOrPhone.text = ""
        tempInvite = MHPInvite(userFirstName: "", userLastName: "", userEmail: "")
        txtFirst.becomeFirstResponder()
    }
    
}

// MARK: - UITableViewControllerDelegate and Datasource

extension MHPInviteEmailOrPhoneViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = pendingInvites?.count else { return 0 }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var inv = MHPInvite(userFirstName: "", userLastName: "", userEmail: "")
        if let invite = pendingInvites?[indexPath.row] {
            inv = invite
        }
        return inv.cellForTableView(tableView: tblView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            pendingInvites!.remove(at: indexPath.row)
            DispatchQueue.main.async { [unowned self] in
                self.tblView.reloadData()
            }
        }
    }
    
}


// MARK: - UITextFieldDelegate

extension MHPInviteEmailOrPhoneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFirst:
            txtFirst.resignFirstResponder()
            txtLast.becomeFirstResponder()
        case txtLast:
            txtLast.resignFirstResponder()
            txtEmailOrPhone.becomeFirstResponder()
        case txtEmailOrPhone:
            txtEmailOrPhone.resignFirstResponder()
        default:
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textEntry = textField.text {
            switch textField {
            case txtFirst:
                tempInvite.userFirstName = textEntry
            case txtLast:
                tempInvite.userLastName = textEntry
            case txtEmailOrPhone:
                tempInvite.userEmail = textEntry
            default:
                return
            }
        }
    }
}


// MARK: - UserInjectable Protocol

extension MHPInviteEmailOrPhoneViewController: Injectable {
    typealias T = [MHPInvite]
    typealias U = MHPUser
    
    func inject(_ invites: T) {
        self.pendingInvites = invites
    }
    
    func inject(_ user: U) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        assert(self.pendingInvites != nil)
        assert(self.mhpUser != nil)
    }
}
