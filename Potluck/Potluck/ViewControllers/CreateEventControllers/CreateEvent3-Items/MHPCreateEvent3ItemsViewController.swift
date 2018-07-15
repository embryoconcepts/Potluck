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
    @IBOutlet weak var btnEdit: UIButton!
    
    var btnInfo = UIBarButtonItem()
    var mhpUser: MHPUser?
    var event: MHPEvent?
    var eventRsvpList: MHPEventRsvpList?
    var invites: [MHPInvite]?
    var eventItemList: MHPEventItemList?
    var dataDelegate: CreateEvent3DataDelegate?
    
    var requestedItems: [MHPRequestedItem]? {
        didSet {
            tblView.reloadData()
        }
    }
    
    
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
        tblView.isEditing = !tblView.isEditing
        if tblView.isEditing {
            btnEdit.titleLabel?.text = "Done"
        } else {
            btnEdit.titleLabel?.text = "Edit"
        }
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
        btnInfo = UIBarButtonItem(image: UIImage(named: "btnInfo.png"), style: .plain, target: self, action: #selector(infoTapped(_: )))
        navigationItem.rightBarButtonItem = btnInfo
        
        if let guests = invites?.count {
            lblSuggestionText.text = "For \(guests) guests, may we suggest the following items and amounts."
        }
    }
    
    fileprivate func setupSuggestedItems() {
        var suggestedItems = [MHPRequestedItem]()
        if let guests = invites?.count {
            
            let categories = [
                "Appetizers": 2,
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
                                                       itemQuantityType: "servings"))
            }
        }
        requestedItems = suggestedItems
    }
    
    fileprivate func addItem() {
        self.tblView.beginUpdates()
        self.tblView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.requestedItems?.insert(MHPRequestedItem(), at: 0)
        self.tblView.endUpdates()
        
        addModifyItemPopover(at: IndexPath(row: 0, section: 0))
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
    // TODO: scroll all when keyboard is shown
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
        return cellItem.cellForTableView(tableView: tblView, atIndexPath: indexPath) as! MHPRequestedItemsCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            requestedItems!.remove(at: indexPath.row)
            DispatchQueue.main.async { [unowned self] in
                self.tblView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        requestedItems!.remove(at: sourceIndexPath.row)
        requestedItems!.insert(requestedItems![sourceIndexPath.row], at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addModifyItemPopover(at: indexPath)
    }
    
}

// Mark: - Info Popover + UIPopoverPresentationControllerDelegate

extension MHPCreateEvent3ItemsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    fileprivate func showInfoPopup() {
        let infoPopover = storyboard?.instantiateViewController(withIdentifier: "MHPSuggestedItemInfoPopoverViewController") as! MHPSuggestedItemInfoPopoverViewController
        
        // set the presentation style
        infoPopover.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        infoPopover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        infoPopover.popoverPresentationController?.delegate = self
        infoPopover.popoverPresentationController?.barButtonItem = btnInfo
        
        // present the popover
        self.present(infoPopover, animated: true, completion: nil)
    }
}


// MARK: - Item Modification Popover

extension MHPCreateEvent3ItemsViewController: ModifyItemPopoverDelegate, CancelAddingNewItemDelegate {
    func addModifyItemPopover(at indexPath: IndexPath) {
        let modifyItemPopover = storyboard?.instantiateViewController(withIdentifier: "MHPModifyItemPopoverViewController") as! MHPModifyItemPopoverViewController
        
        // set up the popover presentation controller
        modifyItemPopover.modalPresentationStyle = UIModalPresentationStyle.popover
        modifyItemPopover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        modifyItemPopover.popoverPresentationController?.delegate = self
        modifyItemPopover.popoverPresentationController?.sourceView = tblView
        modifyItemPopover.popoverPresentationController?.sourceRect = tblView.rectForRow(at: indexPath)
        
        // present the popover
        self.present(modifyItemPopover, animated: true, completion: nil)
        
        // populate the popover with original item
        guard let originalItem = requestedItems?[indexPath.row] else { return }
        modifyItemPopover.modifyItemDelegate = self
        modifyItemPopover.cancelItemDelegate = self
        modifyItemPopover.setupPopover(with: originalItem, at: indexPath)
    }
    
    func saveModifiedItem(with modifiedItem: MHPRequestedItem, at indexPath: IndexPath) {       
        requestedItems?[indexPath.row].itemName = modifiedItem.itemName
        requestedItems?[indexPath.row].itemQuantity = modifiedItem.itemQuantity
        requestedItems?[indexPath.row].itemQuantityType = modifiedItem.itemQuantityType
        
        DispatchQueue.main.async { [unowned self] in
            self.tblView.reloadData()
        }
    }
    
    func cancelAddingNewItem(at indexPath: IndexPath) {
        requestedItems!.remove(at: indexPath.row)
        DispatchQueue.main.async { [unowned self] in
            self.tblView.reloadData()
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
