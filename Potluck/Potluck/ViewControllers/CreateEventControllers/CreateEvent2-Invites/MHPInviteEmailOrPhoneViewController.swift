//
//  MHPInviteEmailOrPhoneViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPInviteEmailOrPhoneViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtEmailOrPhone: UITextField!
    @IBOutlet weak var btnAddToList: UIButton!
    
    var event: MHPEvent?
    let tempInvite = MHPInvite(userFirstName: "", userLastName: "")
    var pendingInvites = [MHPInvite]()
    
    
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
        // TODO: all fields must be != ""
        pendingInvites.append(tempInvite)
        tblView.reloadData()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guestsSelected()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        // TODO: alert about losing pending invites
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func guestsSelected() {
        // TODO: create delegate to pass pending invites back to main Invites view
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
