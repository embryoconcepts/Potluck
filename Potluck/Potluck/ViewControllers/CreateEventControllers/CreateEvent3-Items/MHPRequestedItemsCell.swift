//
//  MHPRequestedItemsCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/10/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol PortionCellValueUpdateDelegate {
    func portionValueDidUpdate(with: Int, for: String)
}

class MHPRequestedItemsCell: UITableViewCell, Configurable {
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var textPortions: UITextField!
    var cellID: String?
    
    var portionDelegate: PortionCellValueUpdateDelegate?
    
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
        
        if let portions = model.itemPortions {
            textPortions.text = "\(portions)"
        } else {
            textPortions.text = ""
        }
    }

}


// MARK: - UITextFieldDelegate

extension MHPRequestedItemsCell: UITextFieldDelegate {    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let portion = textField.text, let id = cellID {
            portionDelegate?.portionValueDidUpdate(with: Int(portion)!, for: id)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // TODO: move textView up when keyboard is present
    
    // TODO: update keyboard to be number pad with "Next" or "Done"
}
