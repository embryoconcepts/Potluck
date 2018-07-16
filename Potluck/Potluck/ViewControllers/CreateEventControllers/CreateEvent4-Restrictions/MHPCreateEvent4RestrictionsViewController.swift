//
//  MHPCreateEvent4RestrictionsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEvent4RestrictionsViewController: UIViewController {
    
    var mhpUser: MHPUser?
    var event: MHPEvent?
    var eventRsvpList: MHPEventRsvpList?
    var invites: [MHPInvite]?
    var requestedItems: [MHPRequestedItem]?
    var eventItemList: MHPEventPledgedItemList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }
}


// MARK: - UserInjectable Protocol

extension MHPCreateEvent4RestrictionsViewController: Injectable {
    typealias T = MHPUser
    typealias E = MHPEvent
    typealias R = MHPEventRsvpList
    typealias I = [MHPInvite]
    typealias S = [MHPRequestedItem]
    typealias L = MHPEventPledgedItemList
    // TODO: add restrictions
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func inject(_ event: E) {
        self.event = event
    }
    
    func inject(_ rsvpList: R) {
        self.eventRsvpList = rsvpList
    }
    
    func inject(_ invites: I) {
        self.invites = invites
    }
    
    func inject(_ requestedItems: S) {
        self.requestedItems = requestedItems
    }
    
    func inject(_ eventItemList: L) {
        self.eventItemList = eventItemList
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
        assert(self.event != nil)
        assert(self.eventRsvpList != nil)
        assert(self.invites != nil)
        assert(self.requestedItems != nil)
        assert(self.eventItemList != nil)
    }
}
