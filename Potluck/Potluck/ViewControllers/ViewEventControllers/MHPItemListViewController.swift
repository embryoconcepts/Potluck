//
//  MHPItemListViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/19/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPItemListViewController: MHPBaseViewController, UITableViewDelegate, UITableViewDataSource, Injectable {

    @IBOutlet weak var btnRsvp: UIButton!
    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblItemListDescription: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    typealias T = (injectedUser: MHPUser, injectedEvent: MHPEvent)
    var user: MHPUser?
    var event: MHPEvent?
    var items = [MHPItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        // TODO: handle moving to rsvp
        // TODO: handle moving to item card
    }

    
    // MARK: - Action Handlers
    
    @IBAction func rsvpTapped(_ sender: Any) {
        goToRsvp()
    }
    
    // MARK: - UITableViewSourceAction
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
    
}
