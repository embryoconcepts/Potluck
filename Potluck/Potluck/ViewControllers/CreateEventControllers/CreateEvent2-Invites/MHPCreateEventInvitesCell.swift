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
        self.lblGuestName.text = "\(String(describing: model.userFirstName)) \(String(describing: model.userLastName))"
        // TODO: self.imgGuest.image = UIImage from self.model?.userProfileURL OR placeholder
    }
}
