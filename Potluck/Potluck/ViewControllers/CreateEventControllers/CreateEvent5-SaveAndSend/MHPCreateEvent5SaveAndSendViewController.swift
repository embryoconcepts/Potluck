//
//  MHPCreateEvent5SaveAndSendViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEvent5SaveAndSendViewController: UIViewController {

    var event: MHPEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
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

extension MHPCreateEvent5SaveAndSendViewController: Injectable {
    typealias T = MHPEvent
    
    func inject(_ event: T) {
        self.event = event
    }
    
    func assertDependencies() {
        assert(self.event != nil)
    }
}
