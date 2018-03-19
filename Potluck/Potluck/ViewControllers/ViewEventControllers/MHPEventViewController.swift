//
//  MHPEventViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPEventViewController: MHPBaseViewController {
    
    @IBOutlet weak var lblEventHost: UILabel!
    @IBOutlet weak var lblEventDescription: UILabel!
    @IBOutlet weak var lblEventDateTime: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var btnRsvp: UIButton!
    @IBOutlet weak var lblGuestListTotals: UILabel!
    @IBOutlet weak var lblMenuTotals: UILabel!
    
    var user: MHPUser?
    var event: MHPEvent?
    var items: [MHPItem]?
    var rsvps: [MHPRsvp]?
    var userDidRsvpForEvent: Bool?
    var userIsHost: Bool?
    var userIsGuest: Bool?
    var userHasRsvp: Bool?
    
    init(user: MHPUser?, event:MHPEvent?, items:[MHPItem]?, rsvps:[MHPRsvp]?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user ?? MHPUser()
        self.event = event ?? MHPEvent()
        self.items = items ?? [MHPItem]()
        self.rsvps = rsvps ?? [MHPRsvp]()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        // TODO: put the below in a completion block with all in the completion
        checkForUserRsvp()
        checkIfUserHostOrGuest()
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
        // TODO: handle moving to rsvp
        // TODO: handle moving to guest list
        // TODO: handle moving to menu
    }
    
    func checkForUserRsvp() {
        // TODO: complete
        userHasRsvp = false
    }
    
    func checkIfUserHostOrGuest() {
        // TODO: complete
        userIsGuest = true
        userIsHost = false
    }
    
    
    // MARK: Styling the View
    
    func styleNavigation() {
        // Navigation Bar
        var rightBarButton: UIBarButtonItem?
        if userIsHost! {
            rightBarButton = UIBarButtonItem(title: "Manage", style: .plain, target: self, action: #selector(manageEvent))
        } else {
            rightBarButton = UIBarButtonItem(title: "RSVP", style: .plain, target: self, action: #selector(rsvpTapped))
        }
        
        navigationItem.rightBarButtonItem = rightBarButton
        self.title = event?.eventName ?? ""
    }
    
    func styleLabels() {
        // Event Details
        lblEventHost.text = event?.eventHost?.userName ?? ""
        lblEventDescription.text = event?.eventDescription ?? ""
        lblEventDateTime.text = event?.eventDate ?? ""
        lblEventLocation.text = event?.eventLocation ?? ""
        
        // RSVP Button
        if userIsHost! || (userIsGuest! && userHasRsvp!) {
            btnRsvp.isHidden = true;
        } else {
            btnRsvp.isHidden = false
        }
        
        // Guest List Summary
//        var guestsConfirmed = 0
//        for rsvp in rsvps! {
//            if rsvp.response == "Yes" || rsvp.response == "Maybe" {
//                guestsConfirmed += 1
//            }
//        }
//        lblGuestListTotals.text = "\(String(describing: rsvps?.count)) invited, \(guestsConfirmed) confirmed"
        lblGuestListTotals.text = ""
        
        // Menu Summary
        lblMenuTotals.text = ""
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func rsvpTapped(_ sender: Any) {
        goToRsvp()
    }
    
    @IBAction func manageEvent(_ sender: Any) {
        // TODO: move to manage event flow
    }
    
    
    // MARK: - Helper Methods
    
    func sendToSignUpLogin() {
        // TODO: move to sign up flow
    }
    
}

