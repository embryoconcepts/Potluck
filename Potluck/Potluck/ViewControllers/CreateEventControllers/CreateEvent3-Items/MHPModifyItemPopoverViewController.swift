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
    
    var isNewItem: Bool?
    var modifiedItem = MHPRequestedItem()
    var indexPath: IndexPath?
    var modifyItemDelegate: ModifyItemPopoverDelegate?
    var cancelItemDelegate: CancelAddingNewItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDoneButton()
        setupKeyboardDismissOnTap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveModifiedItem()
    }
    
    
    // MARK: - Style Popover
    
    func setupPopover(with itemToEdit: MHPRequestedItem, at indexPath: IndexPath, isNew: Bool) {
        self.indexPath = indexPath
        self.modifiedItem = itemToEdit
        self.isNewItem = isNew
        
        if !isNew {
            txtName.text = modifiedItem.name
            if let quantity = modifiedItem.quantity {
                txtQuantity.text = String(describing: quantity)
            }
            txtPortions.text = modifiedItem.quantityType
            checkIfSaveEnabled()
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func checkIfSaveEnabled() {
        if txtName.text != nil, txtName.text != "",
            txtQuantity.text != nil, txtQuantity.text != "",
            txtPortions.text != nil, txtPortions.text != "" {
            btnSave.isEnabled = true
        } else {
            btnSave.isEnabled = false
        }
    }
    
    fileprivate func cancel() {
        self.dismiss(animated: true) {
            if let _ = self.isNewItem {
                self.cancelItemDelegate?.cancelAddingNewItem(at: self.indexPath!)
            }
        }
    }
    
    fileprivate func saveModifiedItem() {
        if let indexPath = indexPath {
            dismiss(animated: true) {
                self.modifyItemDelegate?.saveModifiedItem(with: self.modifiedItem, at: indexPath)
            }
        }
    }
    
}


// MARK: - UITextFieldDelegate and Keyboard Methods

extension MHPModifyItemPopoverViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
        switch textField {
        case txtName:
            modifiedItem.name = text
        case txtQuantity:
            modifiedItem.quantity = Int(text)
        default:
            modifiedItem.quantityType = text
        }
        checkIfSaveEnabled()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtName.resignFirstResponder()
            txtQuantity.becomeFirstResponder()
        case txtQuantity:
            txtQuantity.resignFirstResponder()
            txtPortions.becomeFirstResponder()
        default:
            txtPortions.resignFirstResponder()
            txtName.becomeFirstResponder()
        }
        return true
    }
    
    func setupKeyboardDoneButton() {
        //init toolbar
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
      
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
      
        //setting toolbar as inputAccessoryView
        self.txtName.inputAccessoryView = toolbar
        self.txtQuantity.inputAccessoryView = toolbar
        self.txtPortions.inputAccessoryView = toolbar
    }
    
    func setupKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch> , with event: UIEvent?) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        modifiedItem.name = txtName.text
        if let quantity = txtQuantity.text {
            modifiedItem.quantity = Int(quantity)
        }
        modifiedItem.quantityType = txtPortions.text
        checkIfSaveEnabled()
    }
}
