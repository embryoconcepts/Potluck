//
//  MHPInviteContactsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/2/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Contacts

protocol ContactsSelectedDelegate {
    func submitFromContacts(pendingInvites: [MHPInvite])
}

class MHPInviteContactsViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allContacts = [CNContact]()
    var filteredContacts: [CNContact]?
    var pendingInvites: [MHPInvite]?
    var contactInvitesDelegate: ContactsSelectedDelegate?
    lazy var request: MHPRequestHandler = {
        return MHPRequestHandler()
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        // Do any additional setup after loading the view.
        filteredContacts = allContacts
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func saveTapped(_ sender: Any) {
        let tempInvites = allContacts
            .filter { $0.isSelected }
            .map { (contact) -> MHPInvite in
                let invite = MHPInvite(userFirstName: contact.givenName,
                                       userLastName: contact.familyName,
                                       userEmail: contact.contactPreference!)
                invite.contactID = contact.identifier
                invite.contactImage = contact.imageData
                return invite
            }
        
        // FIXME: fix timing
//        for temp in tempInvites {
//            self.request.retrieveUserByEmail(email: temp.userEmail!) { (result) in
//                switch result {
//                case .success(let user):
//                    temp.userID = user.userID
//                    temp.userProfileURL = user.userProfileURL
//                case .failure(_):
//                    print()
//                }
//            }
//        }
        
        if pendingInvites!.count < 1 {
            pendingInvites?.append(contentsOf: tempInvites)
        } else {
            for invite in pendingInvites! {
                for temp in tempInvites {
                    if invite.contactID != temp.contactID {
                        pendingInvites?.append(temp)
                    }
                }
            }
        }
        
        contactInvitesDelegate?.submitFromContacts(pendingInvites: pendingInvites!)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    func cancel() {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: "Cancel Invites",
                                          message: "Are you sure you want to cancel inviting guests? All invites on this screen will be lost.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
                self.searchBar.text = nil
                self.searchBar.setShowsCancelButton(false, animated: true)
                self.searchBar.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    
    // MARK: - Contacts Methods
    
    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: Error?) -> Void in
                if authorized {
                    self.retrieveContacts(with: store)
                }
            })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContacts(with: store)
        }
    }
    
    func retrieveContacts(with store: CNContactStore) {
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey as CNKeyDescriptor,
                    CNContactImageDataKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                if !contact.emailAddresses.isEmpty {
                    self.allContacts.append(contact)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        updateContactsWithPreviouslySelected()
    }
    
    func updateContactsWithPreviouslySelected() {
        for invite in self.pendingInvites! {
            for contact in allContacts {
                if invite.contactID == contact.identifier {
                    contact.isSelected = true
                    contact.contactPreference = invite.userEmail
                }
            }
        }
    }
    
}


// MARK: - UITableViewControllerDelegate and Datasource

extension MHPInviteContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contacts = filteredContacts else { return 0 }
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contact = CNContact()
        if let contacts = filteredContacts {
            contact = contacts[indexPath.row]
        }
        return contact.cellForTableView(tableView: tblView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MHPContactsCell, let contacts = filteredContacts {
            let contact = contacts[indexPath.row]
            contact.isSelected = !contact.isSelected
            
            if contact.isSelected {
                contactSelected(cell: cell, contact: contact)
            } else {
                contactDeselected(cell: cell, contacts: contacts, indexPath: indexPath)
            }
        }
        tblView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func contactSelected(cell: MHPContactsCell, contact: CNContact) {
        cell.accessoryType = .checkmark
        
        DispatchQueue.main.async { [unowned self] in
            if contact.emails.count == 1 {
                contact.contactPreference = contact.emails.first!
                cell.lblEmailOrPhone.text = contact.contactPreference
                cell.lblNameTop.constant = 8
                cell.lblEmailHeight.constant = 14
            } else if contact.emails.count > 1 {
                let alertController = UIAlertController(title: "Multiple Emails", message: "Which email would you like to use?", preferredStyle: .actionSheet)
                
                for email in contact.emails {
                    let button = UIAlertAction(title: email, style: .default) { (action) in
                        contact.contactPreference = email
                        cell.lblEmailOrPhone.text = contact.contactPreference
                        cell.lblNameTop.constant = 8
                        cell.lblEmailHeight.constant = 14
                    }
                    alertController.addAction(button)
                }
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelButton)
                
                self.present(alertController, animated: true) {
                    cell.lblEmailOrPhone.text = contact.contactPreference
                }
            } else {
                cell.lblNameTop.constant = 18
                cell.lblEmailHeight.constant = 0
            }
        }
    }
    
    fileprivate func contactDeselected(cell: MHPContactsCell, contacts: [CNContact], indexPath: IndexPath) {
        cell.accessoryType = .none
        contacts[indexPath.row].isSelected = false
        contacts[indexPath.row].contactPreference = ""
        cell.lblEmailOrPhone.text = ""
        cell.lblNameTop.constant = 18
        cell.lblEmailHeight.constant = 0
        
        for (i, invite) in self.pendingInvites!.enumerated().reversed() {
            if invite.contactID == contacts[indexPath.row].identifier {
                self.pendingInvites?.remove(at: i)
            }
        }
    }
    
    
}


// MARK: - UISearchBarDelegate

extension MHPInviteContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredContacts = searchContacts(for: searchText)
        } else {
            filteredContacts = allContacts
        }
        DispatchQueue.main.async { [unowned self] in
            self.tblView.reloadData()
        }
    }
    
    func searchContacts(for substring: String) -> [CNContact] {
        var resultArray: [CNContact] = [CNContact]()
        
        for contact in allContacts {
            if contact.familyName.lowercased().contains(substring.lowercased()) ||
                contact.givenName.lowercased().contains(substring.lowercased()) {
                resultArray.append(contact)
            }
        }
        return [CNContact](Set(resultArray))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancel()
    }
    
}

// MARK: - UserInjectable Protocol

extension MHPInviteContactsViewController: Injectable {
    typealias T = [MHPInvite]
    
    func inject(_ invites: T) {
        self.pendingInvites = invites
    }
    
    func assertDependencies() {
        assert(self.pendingInvites != nil)
    }
}
