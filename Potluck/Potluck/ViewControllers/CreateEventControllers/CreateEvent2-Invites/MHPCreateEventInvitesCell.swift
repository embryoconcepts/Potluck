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
    @IBOutlet weak var lblEmailOrPhone: UILabel!
    @IBOutlet weak var imgGuest: UIImageView!

    typealias T = MHPInvite
    var model: MHPInvite?

    func configureWithModel(_ model: MHPInvite) {
        self.model = model

        if let first = model.userFirstName, let last = model.userLastName {
            self.lblGuestName.text = "\(first) \(last)"
        }

        self.lblEmailOrPhone.text = model.email

        if let userPlaceholder = UIImage(named: "userPlaceholder") {
            if let urlString = self.model?.userProfileURL, let url = URL(string: urlString) {
                self.imgGuest.kf.setImage(with: url, placeholder: userPlaceholder)
            } else if let imageData = self.model?.contactImage {
                self.imgGuest.image = UIImage(data: imageData)
            } else {
                self.imgGuest.image = userPlaceholder
            }
        }

    }
}
