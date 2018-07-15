//
//  MHPModifyItemPopoverViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/14/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol ModifyItemPopoverDelegate {
    func saveModifiedItem(with modifiedItem: MHPRequestedItem, at indexPath: IndexPath)
}

protocol CancelAddingNewItemDelegate {
    func cancelAddingNewItem(at indexPath: IndexPath)
}

class MHPModifyItemPopoverViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtPortions: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var indexPath: IndexPath?
    var modifyItemDelegate: ModifyItemPopoverDelegate?
    var cancelItemDelegate: CancelAddingNewItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.checkIfSaveEnabled()
        self.dismiss(animated: true) {
            if !self.btnSave.isEnabled {
                self.cancelItemDelegate?.cancelAddingNewItem(at: self.indexPath!)
            }
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveModifiedItem()
    }
    
    func setupPopover(with originalItem: MHPRequestedItem, at indexPath: IndexPath) {
        if let name = originalItem.itemName {
            txtName.text = name
        }
        if let quantity = originalItem.itemQuantity {
            txtQuantity.text = String(quantity)
        }
        if let type = originalItem.itemQuantityType {
            txtPortions.text = type
        }
        
        self.indexPath = indexPath
    }
    
    func checkIfSaveEnabled() {
        if txtName.text == nil || txtName.text == "" ||
            txtPortions.text == nil || txtPortions.text == "" ||
            txtQuantity.text == nil || txtQuantity.text == ""  {
            btnSave.isEnabled = false
        } else {
            btnSave.isEnabled = true
        }
    }
    
    func saveModifiedItem() {
        if let name = txtName.text,
            let quantity = txtQuantity.text,
            let type = txtPortions.text,
            let indexPath = indexPath {
            
            let modifiedItem = MHPRequestedItem(itemName: name,
                                                itemQuantity: Int(quantity),
                                                itemQuantityType: type)
            
            dismiss(animated: true) {
                self.modifyItemDelegate?.saveModifiedItem(with: modifiedItem, at: indexPath)
            }
        }
    }

}

extension MHPModifyItemPopoverViewController: UITextFieldDelegate {
    // TODO: slide view up to accommodate the keyboard correctly
    // TODO: add "done" to keyboards so number pad can be dismissed
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtName:
            txtName.text = textField.text
        case txtQuantity:
            txtQuantity.text = textField.text
        default:
            txtPortions.text = textField.text
        }
        checkIfSaveEnabled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtPortions.resignFirstResponder()
            txtName.becomeFirstResponder()
        case txtQuantity:
            txtName.resignFirstResponder()
            txtQuantity.becomeFirstResponder()
        default:
            txtQuantity.resignFirstResponder()
            txtPortions.becomeFirstResponder()
        }
        return true
    }
}
