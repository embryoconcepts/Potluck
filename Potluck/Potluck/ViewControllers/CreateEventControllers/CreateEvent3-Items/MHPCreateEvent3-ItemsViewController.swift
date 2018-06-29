//
//  MHPCreateEvent3-ItemsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEvent3_ItemsViewController: UIViewController {

    var mhpUser: MHPUser?
    var event: MHPEvent?
    var eventRsvpList: MHPEventRsvpList?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

}


// MARK: - UserInjectable Protocol

extension MHPCreateEvent3_ItemsViewController: Injectable {
    typealias T = MHPUser
    typealias U = MHPEvent
    typealias R = MHPEventRsvpList
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func inject(_ event: U) {
        self.event = event
    }
    
    func inject(_ eventRsvpList: R) {
        self.eventRsvpList = eventRsvpList
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
        assert(self.event != nil)
        assert(self.eventRsvpList != nil)
    }
}
