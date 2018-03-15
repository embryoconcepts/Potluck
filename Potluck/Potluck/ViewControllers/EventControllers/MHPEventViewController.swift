//
//  MHPEventViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPEventViewController: UIViewController {
    
    @IBOutlet weak var lblEventHost: UILabel!
    @IBOutlet weak var lblEventDescription: UILabel!
    @IBOutlet weak var lblEventDateTime: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var btnRsvp: UIButton!
    @IBOutlet weak var lblGuestListTotals: UILabel!
    @IBOutlet weak var lblMenuTotals: UILabel!
    
    var user: User?
    var event: Event?
    var items: [Item]?
    var rsvps: [Rsvp]?
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
        // TODO: put the below in a completion block with setupDetails in the completion
        checkForUserRsvp()
        checkIfUserHostOrGuest()
        setupDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Action Handlers
    @IBAction func rsvpTapped(_ sender: Any) {
        // TODO: move to RSVP screen
    }
    
    @IBAction func manageEvent(_ sender: Any) {
        // TODO: move to manage event flow
    }
    
    @IBAction func guestListTapped(_ sender: Any) {
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
    }
   
    func checkForUserRsvp() {
        userHasRsvp = false
    }
    
    func checkIfUserHostOrGuest() {
        userIsGuest = true
        userIsHost = false
    }
    
    func setupDetails() {
        // Navigation Bar
        var rightBarButton: UIBarButtonItem?
        if userIsHost! {
            rightBarButton = UIBarButtonItem(title: "Manage", style: .plain, target: self, action: #selector(manageEvent))
        } else {
            rightBarButton = UIBarButtonItem(title: "RSVP", style: .plain, target: self, action: #selector(rsvpTapped(_:)))
        }
        
        navigationItem.rightBarButtonItem = rightBarButton
        if let tempTitle = event?.eventName {
            self.title = tempTitle
        }
        
        // Event Details
        if let tempHost = event?.eventHostID?.userName {
            lblEventHost.text = tempHost
        } else {
            lblEventHost.text = ""
        }
        if let tempEventDesc = event?.eventDescription {
            lblEventDescription.text = tempEventDesc
        } else {
            lblEventDescription.text = ""
        }
        if let tempEventDate = event?.eventDate {
            lblEventDateTime.text = tempEventDate
        } else {
            lblEventDateTime.text = ""
        }
        if let tempEventLocation = event?.eventLocation {
            lblEventLocation.text = tempEventLocation
        } else {
            lblEventLocation.text = ""
        }
        
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
        
        // Menu Summary
        lblMenuTotals.text = ""
    }
    
    func sendToSignUpLogin() {
        // TODO: move to sign up flow
    }
}
