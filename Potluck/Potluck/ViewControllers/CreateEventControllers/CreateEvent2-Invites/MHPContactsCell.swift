//
//  MHPContactsCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/2/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class MHPContactsCell: UITableViewCell, Configurable {
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var lblEmailOrPhone: UILabel!
    @IBOutlet weak var imgGuest: UIImageView!
    @IBOutlet weak var lblNameTop: NSLayoutConstraint!
    @IBOutlet weak var lblEmailHeight: NSLayoutConstraint!
    
    typealias T = CNContact
    var model: CNContact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureWithModel(_ model: CNContact) {
        self.model = model
            self.lblGuestName.text = "\(model.givenName) \(model.familyName)"
        
        if model.contactPreference != "" {
            self.lblEmailOrPhone.text = model.contactPreference
            self.lblNameTop.constant = 8
            self.lblEmailHeight.constant = 14
        } else {
            self.lblNameTop.constant = 18
            self.lblEmailHeight.constant = 0
        }
        
        if model.isSelected {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
        
        // TODO: add user image from contacts
//        if let url = self.model?.imageData {
//            self.imgGuest.image = UIImage(url)
//        } else {
            self.imgGuest.image = UIImage(named: "userPlaceholder")
//        }
    }

}
