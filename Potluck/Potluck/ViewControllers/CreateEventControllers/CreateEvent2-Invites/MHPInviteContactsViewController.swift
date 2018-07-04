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
    var contactsSearchResult = [CNContact]()
    var pendingInvites = [MHPInvite]()
    var contactInvitesDelegate: ContactsSelectedDelegate?
    lazy var request: MHPRequestHandler = {
        return MHPRequestHandler()
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Action Handlers
    
    @IBAction func saveTapped(_ sender: Any) {
        var selectedItems: [CNContact] {
            return allContacts.filter { return $0.isSelected }
        }
        
        pendingInvites = selectedItems.map { (contact) -> MHPInvite in
            return MHPInvite(userFirstName: contact.givenName,
                             userLastName: contact.familyName,
                             userEmail: (contact.emailAddresses.first?.value.description ?? ""))
        }
        contactInvitesDelegate?.submitFromContacts(pendingInvites: pendingInvites)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    func cancel() {
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
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                self.allContacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}


// MARK: - UITableViewControllerDelegate and Datasource

extension MHPInviteContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
           return contactsSearchResult.count
        } else {
            return allContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contact = CNContact()
        if searchBar.text != "" {
            contact = contactsSearchResult[indexPath.row]
        } else {
            contact = allContacts[indexPath.row]
        }
        return contact.cellForTableView(tableView: tblView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

}


// MARK: - UISearchBarDelegate

extension MHPInviteContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            contactsSearchResult = searchContacts(for: searchText)
        } else {
            contactsSearchResult = allContacts
        }
        tblView.reloadData()
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
