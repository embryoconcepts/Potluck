//
//  MHPCreateEvent3ItemsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol CreateEvent3DataDelegate {
    func back(user: MHPUser, event: MHPEvent, invites: [MHPInvite], rsvpList: MHPEventRsvpList)
}

class MHPCreateEvent3ItemsViewController: UIViewController {

    var mhpUser: MHPUser?
    var event: MHPEvent?
    var eventRsvpList: MHPEventRsvpList?
    var invites: [MHPInvite]?
    
    var dataDelegate: CreateEvent3DataDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func back() {
        if let user = mhpUser,
            let event = event,
            let invites = invites,
            let rsvpList = eventRsvpList {
            dataDelegate?.back(user: user, event: event, invites: invites, rsvpList: rsvpList)
        }
    }

    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }
}


// MARK: - UserInjectable Protocol

extension MHPCreateEvent3ItemsViewController: Injectable {
    typealias T = MHPUser
    typealias U = MHPEvent
    typealias R = MHPEventRsvpList
    typealias I = [MHPInvite]
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func inject(_ event: U) {
        self.event = event
    }
    
    func inject(_ rsvpList: R) {
        self.eventRsvpList = rsvpList
    }
    
    func inject(_ invites: I) {
        self.invites = invites
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
        assert(self.event != nil)
        assert(self.eventRsvpList != nil)
        assert(self.invites != nil)
    }
}
