//
//  MHPInviteContactsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/2/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol ContactsSelectedDelegate {
    func submitFromContacts(pendingInvites: [MHPInvite])
}

class MHPInviteContactsViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tempInvite = MHPInvite(userFirstName: "", userLastName: "")
    var pendingInvites = [MHPInvite]()
    var contactInvitesDelegate: ContactsSelectedDelegate?
    lazy var request: MHPRequestHandler = {
        return MHPRequestHandler()
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Action Handlers
    
    @IBAction func saveTapped(_ sender: Any) {
        contactInvitesDelegate?.submitFromContacts(pendingInvites: pendingInvites)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
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


// MARK: - UITableViewControllerDelegate and Datasource

extension MHPInviteContactsViewController: UITableViewDelegate, UITableViewDataSource {
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


// MARK: - UISearchBarDelegate

extension MHPInviteContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
//            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
