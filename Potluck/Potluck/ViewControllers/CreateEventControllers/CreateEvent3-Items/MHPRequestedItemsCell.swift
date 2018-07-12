//
//  MHPRequestedItemsCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/10/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol QuantityValueDidUpdateDelegate {
    func quantityValueDidUpdate(with: Int, for: String)
}

protocol QuantityTypeDidUpdateDelegate {
    func quantityTypeDidUpdate(with: String, for: String)
}

class MHPRequestedItemsCell: UITableViewCell, Configurable {
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var textPortions: UITextField!
    @IBOutlet weak var btnQuantityType: UIButton!
    
    var cellID: String?
    var portionDelegate: QuantityValueDidUpdateDelegate?
    var typeDelegate: QuantityTypeDidUpdateDelegate?
    
    typealias T = MHPRequestedItem
    var model: MHPRequestedItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textPortions.delegate = self
    }
    
    func configureWithModel(_ model: MHPRequestedItem) {
        cellID = model.itemID
        
        if let name = model.itemName {
            lblItemName.text = "\(name)"
        } else {
            lblItemName.text = ""
        }
        
        if let quantity = model.itemQuantity {
            textPortions.text = "\(quantity)"
        } else {
            textPortions.text = ""
        }
        
        if let type = model.itemQuantityType {
            textPortions.text = "\(type)"
        } else {
            textPortions.text = ""
        }
    }

}


// MARK: - QuantityType Popup Delgate

extension MHPRequestedItemsCell {
    // TODO: add popup to select other types, maybe add enum for those types
    
    
    @IBAction func quantityTypeTapped(_ sender: Any) {
        guard let type =  btnQuantityType.titleLabel?.text else { return }
        quantityTypeValueDidChange(to: type)
    }
    
    func quantityTypeValueDidChange(to newType: String) {
        typeDelegate?.quantityTypeDidUpdate(with: cellID!, for: newType)
    }
}


// MARK: - UITextFieldDelegate

extension MHPRequestedItemsCell: UITextFieldDelegate {    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let portion = textField.text, let id = cellID {
            portionDelegate?.quantityValueDidUpdate(with: Int(portion)!, for: id)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // TODO: move tblView up when keyboard is present, focus on cell being edited
    
    // TODO: update keyboard to be number pad with "Next" or "Done"
}
