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
    
    typealias T = CNContact
    var model: CNContact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureWithModel(_ model: CNContact) {
        self.model = model
            self.lblGuestName.text = "\(model.givenName) \(model.familyName)"
        
        // FIXME: fix spacing to center name if email not present
        if let contact = model.contactPreference {
            self.lblEmailOrPhone.text = contact
            self.lblEmailOrPhone.isHidden = false
        } else {
            self.lblEmailOrPhone.isHidden = true
        }
        
        // TODO: add user image from contacts
//        if let url = self.model?.imageData {
//            self.imgGuest.image = UIImage(url)
//        } else {
            self.imgGuest.image = UIImage(named: "userPlaceholder")
//        }
    }

}
