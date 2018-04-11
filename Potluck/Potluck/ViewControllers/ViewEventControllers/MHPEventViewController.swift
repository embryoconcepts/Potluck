//
//  MHPEventViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPEventViewController: MHPBaseViewController, Injectable {
    
    @IBOutlet weak var lblEventHost: UILabel!
    @IBOutlet weak var lblEventDescription: UILabel!
    @IBOutlet weak var lblEventDateTime: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var btnRsvp: UIButton!
    @IBOutlet weak var lblGuestListTotals: UILabel!
    @IBOutlet weak var lblMenuTotals: UILabel!
    
    typealias T = (injectedUser: MHPUser, injectedEvent: MHPEvent)
    var user: MHPUser?
    var event: MHPEvent?
    var items: [MHPItem]?
    var rsvps: [MHPRsvp]?
    var userDidRsvpForEvent: Bool?
    var userIsHost: Bool?
    var userIsGuest: Bool?
    var userHasRsvp: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        // retrieve rsvps and items for event (user and event data should have been passed in segue)
        userIsHost = false // TODO: remove for production
        
        styleNavigation()
        styleLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        // handle moving to rsvp

        if segue.identifier == "EventToGuestList" {
            let guestListVC = segue.destination as? MHPGuestListViewController
            if let tempEvent = event, let tempUser = user {
                guestListVC?.inject((injectedUser: tempUser, injectedEvent:tempEvent))
            }
        }
        
        if segue.identifier == "EventToItemList" {
            let itemListVC = segue.destination as? MHPItemListViewController
            if let tempEvent = event, let tempUser = user {
                itemListVC?.inject((injectedUser: tempUser, injectedEvent:tempEvent))
            }
        }
    }
    

    // MARK: Styling the View
    
    func styleNavigation() {
        // Navigation Bar
        var rightBarButton: UIBarButtonItem?
        if userIsHost != nil {
            rightBarButton = UIBarButtonItem(title: "Manage", style: .plain, target: self, action: #selector(manageEvent))
        } else {
            rightBarButton = UIBarButtonItem(title: "RSVP", style: .plain, target: self, action: #selector(rsvpTapped))
        }
        
        navigationItem.rightBarButtonItem = rightBarButton
        self.title = event?.eventName ?? ""
    }
    
    func styleLabels() {
        // Event Details
        lblEventHost.text = event?.eventHost?.userFirstName ?? ""
        lblEventDescription.text = event?.eventDescription ?? ""
        lblEventDateTime.text = event?.eventDate ?? ""
        lblEventLocation.text = event?.eventLocation ?? ""
        
        // RSVP Button
        if userIsHost != nil || (userIsGuest != nil && userHasRsvp != nil) {
            btnRsvp.isHidden = true;
        } else {
            btnRsvp.isHidden = false
        }
        
        // Guest List Summary
        var guestsConfirmed = 0
        if let safeRsvps = rsvps {
            for rsvp in safeRsvps {
                if rsvp.response == "YES" {
                    guestsConfirmed += 1
                }
            }
        }
        lblGuestListTotals.text = "\(rsvps?.count ?? 0) invited, \(guestsConfirmed) confirmed"
        
        // Menu Summary
        var pledged = 0
        if let safeItems = items {
            for item in safeItems {
                if (item.user != nil) {
                    pledged += 1
                }
            }
        }
        lblMenuTotals.text = "\(items?.count ?? 0) items requested, \(pledged) items pledged"
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func rsvpTapped(_ sender: Any) {
        goToRsvp()
    }
    
    @IBAction func manageEvent(_ sender: Any) {
        // move to manage event flow
    }
    
    
    // MARK: - Injectable Protocol
    
    func inject(_ data: (injectedUser: MHPUser, injectedEvent: MHPEvent)) {
        user = data.injectedUser
        event = data.injectedEvent
    }
    
    func assertDependencies() {
        assert(user != nil)
        assert(event != nil)
    }
    
    
    // MARK: - Helper Methods
    
    func sendToSignUpLogin() {
        // move to sign up flow
    }
    
}
