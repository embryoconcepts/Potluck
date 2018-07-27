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
    func back(event: MHPEvent)
}

class MHPCreateEvent3ItemsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblSuggestionText: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    var btnInfo = UIBarButtonItem()
    var event: MHPEvent?
    var dataDelegate: CreateEvent3DataDelegate?
    
    var requestedItems: [MHPRequestedItem]? {
        didSet {
            tblView.reloadData()
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
        styleView()
        
        if event?.requestedItems == nil || event?.requestedItems?.count == 0 {
            setupSuggestedItems()
        } else {
            requestedItems = event!.requestedItems
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
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(back(sender: )))
        self.navigationItem.leftBarButtonItem = newBackButton

        
        btnInfo = UIBarButtonItem(image: UIImage(named: "btnInfo.png"), style: .plain, target: self, action: #selector(infoTapped(_: )))
        navigationItem.rightBarButtonItem = btnInfo
        
        if let guests = event!.invites?.count {
            lblSuggestionText.text = "For \(guests) guests, may we suggest the following items and amounts."
        }
        
        // set up scrollview + keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardFrame.height + 70
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    fileprivate func setupSuggestedItems() {
        var suggestedItems = [MHPRequestedItem]()
        if let guests = event!.rsvpList?.rsvps?.count {
            
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
                suggestedItems.append(MHPRequestedItem(name: name,
                                                       quantity: Int((Double(guests) * multiplier).rounded(FloatingPointRoundingRule.awayFromZero)),
                                                       quantityType: "servings"))
            }
        }
        requestedItems = suggestedItems
    }
    
    fileprivate func addItem() {
        self.tblView.beginUpdates()
        self.tblView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.requestedItems?.insert(MHPRequestedItem(), at: 0)
        self.tblView.endUpdates()
        
        addModifyItemPopover(at: IndexPath(row: 0, section: 0), for: true)
    }
    
    fileprivate func next() {
        createEventItemList()
            if  let event = event,
                let createEvent4 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent4RestrictionsViewController") as? MHPCreateEvent4RestrictionsViewController {
                createEvent4.dataDelegate = self
                createEvent4.inject(event)
                navigationController?.pushViewController(createEvent4, animated: true)
            }
    }
    
    fileprivate func createEventItemList() {
        if let items = requestedItems {
            event?.requestedItems = items
        }
    }
    
    @objc fileprivate func back(sender: UIBarButtonItem) {
        createEventItemList()
        if let event = event {
            dataDelegate?.back(event: event)
        }
        navigationController?.popViewController(animated: true)
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
        addModifyItemPopover(at: indexPath, for: false)
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
    func addModifyItemPopover(at indexPath: IndexPath, for isNewItem: Bool) {
        let modifyItemPopover = storyboard?.instantiateViewController(withIdentifier: "MHPModifyItemPopoverViewController") as! MHPModifyItemPopoverViewController
        
        // set up the popover presentation controller
        modifyItemPopover.modalPresentationStyle = UIModalPresentationStyle.popover
        modifyItemPopover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        modifyItemPopover.popoverPresentationController?.delegate = self
        modifyItemPopover.popoverPresentationController?.sourceView = tblView
        modifyItemPopover.popoverPresentationController?.sourceRect = tblView.rectForRow(at: indexPath)
        
        // present the popover
        self.present(modifyItemPopover, animated: true, completion: nil)
        
        // populate the popover with original item
        guard let originalItem = requestedItems?[indexPath.row] else { return }
        modifyItemPopover.modifyItemDelegate = self
        modifyItemPopover.cancelItemDelegate = self
        modifyItemPopover.setupPopover(with: originalItem, at: indexPath, isNew: isNewItem)
    }
    
    func saveModifiedItem(with modifiedItem: MHPRequestedItem, at indexPath: IndexPath) {       
        requestedItems?[indexPath.row].name = modifiedItem.name
        requestedItems?[indexPath.row].quantity = modifiedItem.quantity
        requestedItems?[indexPath.row].quantityType = modifiedItem.quantityType
        
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


// MARK: - CreateEvent4DataDelegate

extension MHPCreateEvent3ItemsViewController: CreateEvent4DataDelegate {
    func back(event: MHPEvent) {
        inject(event)
    }
}


// MARK: - UserInjectable Protocol

extension MHPCreateEvent3ItemsViewController: Injectable {
    typealias T = MHPEvent

    func inject(_ event: T) {
        self.event = event
    }

    func assertDependencies() {
        assert(self.event != nil)
    }
}
