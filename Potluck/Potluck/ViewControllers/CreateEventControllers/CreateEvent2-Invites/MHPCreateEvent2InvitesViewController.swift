//
//  MHPCreateEvent2InvitesViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/27/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import UIKit

class MHPCreateEvent2InvitesViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblGuestList: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    var mhpUser: MHPUser?
    var event: MHPEvent?
    var invites = [MHPInvite]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
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
    
    }
    
    @IBAction func emailTapped(_ sender: Any) {
    
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
    
    }
    
    @IBAction func cancelTappped(_ sender: UIButton) {
        cancel()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        next()
    }
    
    
    // MARK: - Private methods
    
    fileprivate func setupView() {
       
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        lblGuestList.text = "Guest List (\(invites.count))"
        tblView.reloadData()
    }
    
    fileprivate func resetView() {
        self.event = nil
        self.mhpUser = nil
        self.invites = [MHPInvite]()
    }
    
    fileprivate func cancel() {
        let alert = UIAlertController(title: "Cancel Event",
                                      message: "Are you sure you want to cancel creating a Potluck? All event data will be lost.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
            self.resetView()
            
            // return to Home
            self.tabBarController?.tabBar.isHidden = false
            if let tabs = self.tabBarController?.viewControllers {
                if tabs.count > 0 {
                    self.tabBarController?.selectedIndex = 0
                }
            }
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    fileprivate func next() {
        if validate() {
            // TODO: update for screen 3
            if  let user = mhpUser,
                let event = event,
                let createEvent2 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent2InvitesViewController") as? MHPCreateEvent2InvitesViewController {
                createEvent2.inject(user)
                createEvent2.inject(event)
                navigationController?.pushViewController(createEvent2, animated: true)
            }
        }
    }
    
    fileprivate func validate() -> Bool {
        let isValid = true
        // TODO: validate info
        return isValid
    }
    
    @objc fileprivate func back() {
        // TODO: double check data injection, may need a delegate instead
        if  let user = mhpUser,
            let event = event,
            let createEvent1 = navigationController?.presentingViewController as? MHPCreateEvent1DetailsViewController {
            // storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent1DetailsViewController") as? MHPCreateEvent1DetailsViewController {
            createEvent1.inject(user)
            createEvent1.inject(event)
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
        if invites.count > 0 {
            return invites.count
        } else {
            return 1
        }
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
            return 20
        } else {
            return tblView.frame.height
        }
    }
    
}

// MARK: - UserInjectable Protocol

extension MHPCreateEvent2InvitesViewController: Injectable {
    typealias T = MHPUser
    typealias U = MHPEvent
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func inject(_ event: U) {
        self.event = event
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
        assert(self.event != nil)
    }
}