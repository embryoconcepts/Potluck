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
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblQuantityType: UILabel!
        
    typealias T = MHPRequestedItem
    var model: MHPRequestedItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithModel(_ model: MHPRequestedItem) {
        
        if let name = model.itemName {
            lblItemName.text = "\(name)"
        } else {
            lblItemName.attributedText = NSAttributedString(string: "Item Name",
                                                            attributes: [.foregroundColor: UIColor.lightGray,
                                                                         .font: UIFont.italicSystemFont(ofSize: 14)])
        }
        
        if let quantity = model.itemQuantity {
            lblQuantity.text = "\(quantity)"
        } else {
            lblQuantity.attributedText = NSAttributedString(string: "##",
                                                            attributes: [.foregroundColor: UIColor.lightGray,
                                                                         .font: UIFont.italicSystemFont(ofSize: 14)])
        }
        
        if let type = model.itemQuantityType {
            lblQuantityType.text = "\(type)"
        } else {
            lblQuantityType.attributedText = NSAttributedString(string: "portions",
                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                              .font: UIFont.italicSystemFont(ofSize: 14)])
        }
    }

}
