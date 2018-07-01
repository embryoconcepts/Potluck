//
//  MHPCreateEventInvitesCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/27/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEventInvitesCell: UITableViewCell, Configurable {
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var imgGuest: UIImageView!
    
    typealias T = MHPInvite
    var model: MHPInvite?
    
    func configureWithModel(_ model: MHPInvite) {
        self.model = model
        if let first = model.userFirstName, let last = model.userLastName {
            self.lblGuestName.text = "\(first) \(last)"
        }
        if let url = self.model?.userProfileURL {
            // TODO: self.imgGuest.image = UIImage(url)
        } else {
            self.imgGuest.image = UIImage(named: "userPlaceholder")
        }
    }
}
