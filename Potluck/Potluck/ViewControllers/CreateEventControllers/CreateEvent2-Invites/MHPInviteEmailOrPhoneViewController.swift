//
//  MHPInviteEmailOrPhoneViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol EnteredInvitesDelegate {
    func submit(pendingInvites: [MHPInvite])
}

class MHPInviteEmailOrPhoneViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtEmailOrPhone: UITextField!
    @IBOutlet weak var btnAddToList: UIButton!
    
    var event: MHPEvent?
    var tempInvite = MHPInvite(userFirstName: "", userLastName: "")
    var pendingInvites = [MHPInvite]()
    var enteredInvitesDelegate: EnteredInvitesDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func addToListTapped(_ sender: Any) {
        // TODO: validate fields, alert if missing info
        pendingInvites.append(tempInvite)
        resetTextFields()
        tblView.reloadData()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        enteredInvitesDelegate?.submit(pendingInvites: pendingInvites)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel Invites",
                                      message: "Are you sure you want to cancel inviting guests? All event data will be lost.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Private Methods
    
    func resetTextFields() {
        txtFirst.text = ""
        txtLast.text = ""
        txtEmailOrPhone.text = ""
        tempInvite = MHPInvite(userFirstName: "", userLastName: "")
        txtFirst.becomeFirstResponder()
    }

}

// MARK: - UITableViewControllerDelegate and Datasource

extension MHPInviteEmailOrPhoneViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let invite = pendingInvites[indexPath.row]
        return invite.cellForTableView(tableView: tblView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            pendingInvites.remove(at: indexPath.row)
            tblView.reloadData()
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
            // TODO: or invite.userPhone = txtEmailOrPhone.text
            default:
                return
            }
        }
    }
}


// MARK: - UserInjectable Protocol

extension MHPInviteEmailOrPhoneViewController: Injectable {
    typealias T = MHPEvent
    
    func inject(_ event: T) {
        self.event = event
    }
    
    func assertDependencies() {
        assert(self.event != nil)
    }
}
