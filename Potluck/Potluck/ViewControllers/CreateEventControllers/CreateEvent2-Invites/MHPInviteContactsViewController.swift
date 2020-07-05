//
//  MHPInviteContactsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/2/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Contacts
import SVProgressHUD

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
        let dispatchGroup = DispatchGroup()
        var tempInvites = [MHPInvite]()
        DispatchQueue.main.async {
            tempInvites = self.allContacts
                .filter { $0.isSelected }
                .map { (contact) -> MHPInvite in
                    let invite = MHPInvite(userFirstName: contact.givenName,
                                           userLastName: contact.familyName,
                                           email: contact.contactPreference!)
                    invite.contactID = contact.identifier
                    invite.contactImage = contact.imageData
                    return invite
                }
                .filter { (invite) -> Bool in
                    if self.pendingInvites!.count > 0, self.pendingInvites!.contains(invite) {
                        return false
                    } else {
                        return true
                    }
                }
                .filter { (invite) -> Bool in
                    SVProgressHUD.show()
                    dispatchGroup.enter()
                    
                    self.request.retrieveUserByEmail(email: invite.email!) { (result) in
                        switch result {
                        case .success(let user):
                            invite.userFirstName = user.firstName
                            invite.userLastName = user.lastName
                            invite.userID = user.userID
                            invite.userProfileURL = user.profileImageURL
                        case .failure(_):
                            print()
                        }
                        
                        dispatchGroup.leave()
                        SVProgressHUD.dismiss()
                    }
                    return true
            }
            
            dispatchGroup.notify(queue: DispatchQueue.global()) {
                self.pendingInvites?.append(contentsOf: tempInvites)
                self.contactInvitesDelegate?.submitFromContacts(pendingInvites: self.pendingInvites!)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
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
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        let alertController = UIAlertController(title: "Access Denied",
                                                                message: "Permission to access your Contacts has been previously denied.If you would like to access your contacts, please update your Contacts permission in Settings.",
                                                                preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                        })
                        alertController.addAction(settingsAction)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
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
        request.sortOrder = .userDefault
        
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                if  (!contact.givenName.isEmpty || !contact.familyName.isEmpty) &&
                    !contact.emailAddresses.isEmpty {
                    self.allContacts.append(contact)
                }
            }
            updateContactsWithPreviouslySelected()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func updateContactsWithPreviouslySelected() {
        for invite in self.pendingInvites! {
            for contact in allContacts {
                if invite.contactID == contact.identifier {
                    contact.isSelected = true
                    contact.contactPreference = invite.email
                }
            }
        }
        
        self.filteredContacts = self.allContacts
        DispatchQueue.main.async {
            self.tblView.reloadData()
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
                contactSelected(cell: cell, contact: contact, indexPath: indexPath)
            } else {
                contactDeselected(cell: cell, contact: contact, indexPath: indexPath)
            }
        }
        tblView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func contactSelected(cell: MHPContactsCell, contact: CNContact, indexPath: IndexPath) {
        
        DispatchQueue.main.async { [unowned self] in
            if contact.emails.count == 1 {
                cell.accessoryType = .checkmark
                contact.contactPreference = contact.emails.first!
                cell.lblEmailOrPhone.text = contact.contactPreference
                cell.lblNameTop.constant = 8
                cell.lblEmailHeight.constant = 14
            } else if contact.emails.count > 1 {
                let alertController = UIAlertController(title: "Multiple Emails",
                                                        message: "Which email would you like to use?",
                                                        preferredStyle: .actionSheet)
                
                for email in contact.emails {
                    let button = UIAlertAction(title: email, style: .default) { (action) in
                        cell.accessoryType = .checkmark
                        contact.contactPreference = email
                        cell.lblEmailOrPhone.text = contact.contactPreference
                        cell.lblNameTop.constant = 8
                        cell.lblEmailHeight.constant = 14
                    }
                    alertController.addAction(button)
                }
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
                    cell.accessoryType = .none
                    contact.isSelected = false
                })
                alertController.addAction(cancelButton)
                
                self.present(alertController, animated: true) {
                    cell.lblEmailOrPhone.text = contact.contactPreference
                }
            } else {
                cell.lblNameTop.constant = 18
                cell.lblEmailHeight.constant = 0
            }
            
            self.validateSelection(for: contact, at: cell, indexPath: indexPath)
        }
    }
    
    fileprivate func validateSelection(for contact: CNContact, at cell: MHPContactsCell, indexPath: IndexPath) {
        if self.pendingInvites!.contains(where: { $0.email == contact.contactPreference }) {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "Existing Invite",
                                                        message: "This user has already been invited.",
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: {
                    self.contactDeselected(cell: cell, contact: contact, indexPath: indexPath)
                })
            }
        }
    }
    
    fileprivate func contactDeselected(cell: MHPContactsCell, contact: CNContact, indexPath: IndexPath) {
        cell.accessoryType = .none
        contact.isSelected = false
        contact.contactPreference = ""
        cell.lblEmailOrPhone.text = ""
        cell.lblNameTop.constant = 18
        cell.lblEmailHeight.constant = 0
        
        for (i, invite) in self.pendingInvites!.enumerated().reversed() {
            if invite.contactID == contact.identifier {
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
