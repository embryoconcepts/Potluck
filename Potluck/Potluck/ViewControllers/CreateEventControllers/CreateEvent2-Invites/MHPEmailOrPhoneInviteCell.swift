//
//  MHPEmailOrPhoneInviteCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPEmailOrPhoneInviteCell: UITableViewCell {
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var imgGuest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(for invite: MHPInvite) {
        lblGuestName.text = "\(String(describing: invite.userFirstName)) \(String(describing: invite.userLastName))"
        // TODO: image
    }

}
