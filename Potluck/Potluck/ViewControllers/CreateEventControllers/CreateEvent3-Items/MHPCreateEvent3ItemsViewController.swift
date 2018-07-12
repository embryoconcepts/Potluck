//
//  MHPCreateEvent3ItemsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
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
    var requestedItems: [MHPRequestedItem]? {
        didSet {
            tblView.reloadData()
        }
    }
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
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func editTapped(_ sender: Any) {
        editItems()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addItem()
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        showInfoPopup()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        next()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func styleView() {
        let btnAddItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editTapped(_: )))
        navigationItem.rightBarButtonItem = btnAddItem
        
        if let guests = invites?.count {
            lblSuggestionText.text = "For \(guests) xx guests we suggest the following. Edit to fit your needs!"
        }
    }
    
    fileprivate func setupSuggestedItems() {
        if let guests = invites?.count {
            let categories = [
                "Appetizers": 2.5,
                "Salad": 1,
                "Mains": 1.25,
                "Side Dishes": 2.5,
                "Bread": 1.25,
                "Drinks": 2,
                "Desserts": 1.25,
                "Utensils": 1.25
            ]
            for (name, multiplier) in categories {
                suggestedItems.append(MHPRequestedItem(itemName: name,
                                                       itemQuantity: Int((Double(guests) * multiplier).rounded(FloatingPointRoundingRule.awayFromZero)),
                                                       itemQuantityType: ""))
            }
        }
        requestedItems = suggestedItems
    }
    
    func editItems() {
        // TODO: allow user to delete and drag/drop
    }
    
    fileprivate func addItem() {
        var newItem = MHPRequestedItem()
        
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: "Add Item", message: "What would you like to add?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField { textField in
                textField.placeholder = "Item Name"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                // handle error
                self.tblView.beginUpdates()
                if let name = alert.textFields?.first?.text {
                    newItem.itemName = name
                    self.tblView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.requestedItems?.insert(newItem, at: 0)
                }
                self.tblView.endUpdates()
            }))
            
            self.present(alert, animated: true)
        }

    }
    
    func showInfoPopup() {
        // TODO: show popup with info on suggested portions and stuff
    }
    
    fileprivate func next() {
        createEventItemList()
        if validate() {
            if  let user = mhpUser,
                let event = event,
                let eventRsvpList = eventRsvpList,
                let invites = invites,
                let items = requestedItems,
                let eventItemList = eventItemList,
                // FIXME: issue with instantiation
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
    
    fileprivate func createEventItemList() {
        if let eventID = event?.eventID,
            let items = requestedItems {
            eventItemList = MHPEventItemList(eventID: eventID,
                                             eventItemListDescription: nil,
                                             eventItemListTags: nil,
                                             eventItems: items)
        }
    }
    
    fileprivate func validate() -> Bool {
        // TODO: complete validation
        return true
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
    // TODO: add header that allows user to edit and add items, reduce copy height, scroll all when keyboard is shown
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
        let cell = cellItem.cellForTableView(tableView: tblView, atIndexPath: indexPath) as! MHPRequestedItemsCell
        cell.portionDelegate = self
        return cell
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
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


// MARK: - QuantityValueDidUpdateDelegate

extension MHPCreateEvent3ItemsViewController: QuantityValueDidUpdateDelegate {
    func quantityValueDidUpdate(with value: Int, for id: String) {
        for item in requestedItems! where item.itemID == id {
            if let index = requestedItems?.index(of: item) {
                requestedItems![index].itemQuantity = value
            }
        }
    }
}


// MARK: - QuantityTypeDidUpdateDelegate

extension MHPCreateEvent3ItemsViewController: QuantityTypeDidUpdateDelegate {
    func quantityTypeDidUpdate(with type: String, for id: String) {
        for item in requestedItems! where item.itemID == id {
            if let index = requestedItems?.index(of: item) {
                requestedItems![index].itemQuantityType = type
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
