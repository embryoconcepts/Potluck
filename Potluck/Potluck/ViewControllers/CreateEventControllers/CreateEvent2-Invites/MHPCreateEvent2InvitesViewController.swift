//
//  MHPCreateEvent2InvitesViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/27/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import UIKit

protocol CreateEvent2DataDelegate {
    func back(event: MHPEvent)
}

class MHPCreateEvent2InvitesViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblGuestList: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    var event: MHPEvent?
    var invites = [MHPInvite]()
    var rsvps = [MHPRsvp]()
    
    var dataDelegate: CreateEvent2DataDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        assertDependencies()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func contactsTapped(_ sender: Any) {
        if let contactsInvite = storyboard?.instantiateViewController(withIdentifier: "MHPInviteContactsViewController") as? MHPInviteContactsViewController {
            contactsInvite.pendingInvites = invites
            contactsInvite.contactInvitesDelegate = self
            present(contactsInvite, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        if let emailInvite = storyboard?.instantiateViewController(withIdentifier: "MHPInviteEmailOrPhoneViewController") as? MHPInviteEmailOrPhoneViewController {
            emailInvite.pendingInvites = invites
            emailInvite.enteredInvitesDelegate = self
            present(emailInvite, animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
    
    }
    
    @IBAction func cancelTappped(_ sender: UIButton) {
        cancel()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        mapInvitesToRsvps()
        updateEventRsvpList()
        next()
    }
    
    
    // MARK: - Private methods
    
    fileprivate func setupView() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(back(sender: )))
        self.navigationItem.leftBarButtonItem = newBackButton
       
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        lblGuestList.text = "Guest List (\(String(describing: invites.count)))"
        DispatchQueue.main.async { [unowned self] in
            self.tblView.reloadData()
        }
    }
    
    fileprivate func resetView() {
        self.event = nil
        self.invites = [MHPInvite]()
    }
    
    fileprivate func mapInvitesToRsvps() {
        rsvps = invites.map { (invite) -> MHPRsvp in
            return MHPRsvp(userID: invite.userID,
                           userEmail: invite.userEmail,
                           eventID: event?.eventID,
                           itemID: MHPPledgedItem().itemID,
                           isGuest: true,
                           isHost: false,
                           response: nil,
                           notificationsOn: false,
                           numOfGuest: 0)
        }
        
        let hostRsvp = MHPRsvp(userID: event?.host?.userID,
                               userEmail: event?.host?.email,
                               eventID: event?.eventID,
                               itemID: MHPPledgedItem().itemID,
                               isGuest: false,
                               isHost: true,
                               response: "yes",
                               notificationsOn: false,
                               numOfGuest: 0)
        rsvps.append(hostRsvp)
        
    }
    
    fileprivate func updateEventRsvpList() {
        event?.rsvpList = MHPEventRsvpList()
        event?.rsvpList?.rsvps = rsvps
        event?.invites = invites
        
        if let host = event?.host?.userID {
            event?.rsvpList?.hostID = host
        }
    }
    
    fileprivate func next() {
        if validate() {
            if  let event = event,
                let createEvent3 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent3ItemsViewController") as? MHPCreateEvent3ItemsViewController {
                createEvent3.inject(event)
                createEvent3.dataDelegate = self
                navigationController?.pushViewController(createEvent3, animated: true)
            }
        }
    }
    
    fileprivate func validate() -> Bool {
        if rsvps.count < 1 {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "No Guests",
                                                        message: "What's a Potluck without guests? Please add some guests to continue.",
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    
    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }
    
    @objc fileprivate func back(sender: UIBarButtonItem) {
        mapInvitesToRsvps()
        updateEventRsvpList()
        if let event = event {
            dataDelegate?.back(event: event)
            navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - UITableViewControllerDelegate and Datasource

extension MHPCreateEvent2InvitesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if invites.count > 0 {
                let invite = invites[indexPath.row]
                return invite.cellForTableView(tableView: tblView, atIndexPath: indexPath)
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyStateCell", for: indexPath) as! MHPInviteEmptyStateCell
            cell.isUserInteractionEnabled = false
            cell.isHighlighted = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if invites.count > 0 {
                return 55
            } else {
                return tblView.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            invites.remove(at: indexPath.row)
            DispatchQueue.main.async { [unowned self] in
                self.tblView.reloadData()
            }
        }
    }

}


// MARK: - EnteredInvitesDelegate

extension MHPCreateEvent2InvitesViewController: EnteredInvitesDelegate {
    func submit(pendingInvites: [MHPInvite]) {
        invites = pendingInvites
    }
}


// MARK: - ContactsSelectedDelegate

extension MHPCreateEvent2InvitesViewController: ContactsSelectedDelegate {
    func submitFromContacts(pendingInvites: [MHPInvite]) {
        invites = pendingInvites
    }
}


// MARK: - CreateEvent2DataDelegate

extension MHPCreateEvent2InvitesViewController: CreateEvent3DataDelegate {
    func back(event: MHPEvent) {
        mapInvitesToRsvps()
        updateEventRsvpList()
        inject(event)
    }
}

// MARK: - UserInjectable Protocol

extension MHPCreateEvent2InvitesViewController: Injectable {
    typealias T = MHPEvent
    
    func inject(_ event: T) {
        self.event = event
        if let eventInvites = event.invites {
            self.invites = eventInvites
        }
    }
    
    func assertDependencies() {
        assert(self.event != nil)
    }
}
