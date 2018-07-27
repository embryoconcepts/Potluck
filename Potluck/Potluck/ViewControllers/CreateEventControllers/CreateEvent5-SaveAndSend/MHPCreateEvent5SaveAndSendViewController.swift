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

    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblInviteCount: UILabel!
    @IBOutlet weak var lblItemsCount: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    var event: MHPEvent?
    var dataDelegate: CreateEvent5DataDelegate?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func switchChanged(_ sender: Any) {
        // TODO: turn notifications on for event, for host
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveAndSend()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func setupView() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(back(sender: )))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        if let name = event?.host?.firstName {
            lblHostName.text = "From your host, \(name):"
        } else {
            lblHostName.text = "From your host:"
        }
        
        if let description = event?.description,
            let date = event?.date,
            let invites = event?.invites?.count,
            let items = event?.requestedItems?.count {
            
            lblDescription.text = description
            lblDateTime.text = date
            lblInviteCount.text = "\(invites) Invitations to be sent"
            lblItemsCount.text = "\(items) items on the Menu"
        }
        
        let location = event?.location ?? ""
        let address = event?.address ?? ""
        if location != "" && address != "" {
            lblLocation.text = "\(location), \(address)"
        } else if location != "" {
            lblLocation.text = location
        } else if address != "" {
            lblLocation.text = address
        }
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
