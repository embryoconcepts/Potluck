//
//  MHPCreateEvent3ItemsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol CreateEvent3DataDelegate {
    func back(user: MHPUser, event: MHPEvent, invites: [MHPInvite], rsvpList: MHPEventRsvpList, requestedItems: [MHPRequestedItem])
}

class MHPCreateEvent3ItemsViewController: UIViewController {

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblSuggestionText: UILabel!
    
    var mhpUser: MHPUser?
    var event: MHPEvent?
    var eventRsvpList: MHPEventRsvpList?
    var invites: [MHPInvite]?
    var suggestedItems = [MHPRequestedItem]()
    var requestedItems: [MHPRequestedItem]?
    var eventItemList: MHPEventItemList?
    
    var dataDelegate: CreateEvent3DataDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
        styleView()
        
        if requestedItems == nil || requestedItems?.count == 0 {
            setupSuggestedItems()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func nextTapped(_ sender: Any) {
        if validate() {
            if  let user = mhpUser,
                let event = event,
                let eventRsvpList = eventRsvpList,
                let invites = invites,
                let items = requestedItems,
                let eventItemList = eventItemList,
                let createEvent4 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent4RestrictionsViewController") as? MHPCreateEvent4RestrictionsViewController {
                createEvent4.inject(user)
                createEvent4.inject(event)
                createEvent4.inject(eventRsvpList)
                createEvent4.inject(invites)
                createEvent4.inject(items)
                createEvent4.inject(eventItemList)
                navigationController?.pushViewController(createEvent4, animated: true)
            }
        }
    }
    
    fileprivate func validate() -> Bool {
        return true
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.presentCancelAlert(view: self)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Private Methods
    
    
    fileprivate func styleView() {
        if let count = invites?.count {
            lblSuggestionText.text = "You’ve invited \(count) guests. Suggested quantities and dishes are listed below. Feel free to edit to best fit your needs! "
        }
    }
    
    fileprivate func setupSuggestedItems() {
        // TODO: calculate and populate suggested items
        requestedItems = suggestedItems
    }
    
    fileprivate func back() {
        if let user = mhpUser,
            let event = event,
            let invites = invites,
            let rsvpList = eventRsvpList,
            let requestedItems = requestedItems {
            dataDelegate?.back(user: user, event: event, invites: invites, rsvpList: rsvpList, requestedItems: requestedItems)
        }
    }

    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }
}


// MARK: - UITableViewControllerDelegate and Datasource

extension MHPCreateEvent3ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = requestedItems?.count else { return 0 }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellItem = MHPRequestedItem()
        if let item = requestedItems?[indexPath.row] {
            cellItem = item
        }
        return cellItem.cellForTableView(tableView: tblView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            requestedItems!.remove(at: indexPath.row)
            DispatchQueue.main.async { [unowned self] in
                self.tblView.reloadData()
            }
        }
    }
    
}


// MARK: - UserInjectable Protocol

extension MHPCreateEvent3ItemsViewController: Injectable {
    typealias T = MHPUser
    typealias E = MHPEvent
    typealias R = MHPEventRsvpList
    typealias I = [MHPInvite]
    typealias S = [MHPRequestedItem]
    
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
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
        assert(self.event != nil)
        assert(self.eventRsvpList != nil)
        assert(self.invites != nil)
    }
}
