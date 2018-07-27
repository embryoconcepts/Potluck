//
//  MHPCreateEvent5SaveAndSendViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol CreateEvent5DataDelegate {
    func back(event: MHPEvent)
}

class MHPCreateEvent5SaveAndSendViewController: UIViewController {

    var event: MHPEvent?
    var dataDelegate: CreateEvent5DataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupView() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(back(sender: )))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    fileprivate func saveAndSend() {
        
    }
    
    @objc fileprivate func back(sender: UIBarButtonItem) {
        if let event = event {
            dataDelegate?.back(event: event)
        }
        navigationController?.popViewController(animated: true)
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
