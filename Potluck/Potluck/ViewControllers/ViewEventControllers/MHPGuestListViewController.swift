//
//  MHPGuestListViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/19/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPGuestListViewController: MHPBaseViewController, UITableViewDelegate, UITableViewDataSource, Injectable {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRSVP: UIButton!
    
    typealias T = (injectedUser: MHPUser, injectedEvent: MHPEvent)
    var user: MHPUser?
    var event: MHPEvent?
    var guestsYes = [MHPRsvp]()
    var guestsNo = [MHPRsvp]()
    var guestsInvited = [MHPRsvp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countRsvps()
        assertDependencies()
        // Do any additional setup after loading the view.
        self.title = event?.eventName ?? "Title"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        // TODO: handle moving to rsvp
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func rsvpTapped(_ sender: Any) {
        goToRsvp()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections = 1
        
        if guestsYes.count >= 1 {
            numOfSections += 1
        }
        
        if guestsNo.count >= 1 {
            numOfSections += 1
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return guestsYes.count
        case 1:
            return guestsInvited.count
        default:
            return guestsNo.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Attending \(guestsYes.count)"
        case 1:
            return "Invited (not yet responded) \(guestsInvited.count)"
        default:
            return "Not Attending \(guestsNo.count)"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestListCell", for: indexPath) as! MHPGuestListCell
        var sectionGuests = [MHPRsvp]()
        switch (indexPath.section) {
            case 0:
                sectionGuests = guestsYes
            case 1:
                sectionGuests = guestsInvited
            default:
                sectionGuests = guestsNo
        }

        cell.lblGuestName.text = sectionGuests[indexPath.row].user?.userFirstName ?? ""
        cell.lblItem.text = sectionGuests[indexPath.row].item?.itemName ?? ""
        
        return cell
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
    
    
    // MARK: - Private Methods
 
    fileprivate func countRsvps() {
        if let tempRsvps = event?.eventRsvpList?.eventRsvps {
            for rsvp in tempRsvps {
                if let response = rsvp.response {
                    // TODO: update w/enum
                    switch response {
                    case "YES":
                        guestsYes.append(rsvp)
                    case "NO":
                        guestsNo.append(rsvp)
                    default:
                        guestsInvited.append(rsvp)
                    }
                }
            }
        }
    }
}
