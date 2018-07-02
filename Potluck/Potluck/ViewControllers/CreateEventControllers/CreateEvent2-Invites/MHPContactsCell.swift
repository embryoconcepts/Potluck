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
    @IBOutlet weak var imgGuest: UIImageView!
    
    typealias T = CNContact
    var model: CNContact?
    
    func configureWithModel(_ model: CNContact) {
        self.model = model
            self.lblGuestName.text = "\(model.givenName) \(model.familyName)"
        
//        if let url = self.model?.imageData {
            // TODO: self.imgGuest.image = UIImage(url)
//        } else {
            self.imgGuest.image = UIImage(named: "userPlaceholder")
//        }
    }
}
