//
//  MHPRequestedItemsCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/10/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPRequestedItemsCell: UITableViewCell, Configurable {
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var textPortions: UITextField!
    
    typealias T = MHPRequestedItem
    var model: MHPRequestedItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithModel(_ model: MHPRequestedItem) {
        lblItemName.text = model.itemName ?? model.itemPlaceholderName
        
        if let portions = model.itemPortions {
            textPortions.text = "\(String(describing: portions))"
        } else {
            textPortions.text =   "\(String(describing: model.itemSuggestedPortions))"
        }
    }

}


// MARK: - UITextFieldDelegate

extension MHPRequestedItemsCell: UITextFieldDelegate {
    
}


