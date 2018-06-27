//
//  MHPCreateEventInvitesCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/27/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEventInvitesCell: UITableViewCell {
    
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
    
    func setupCell(with guest: MHPUser) {
        lblGuestName.text = "\(String(describing: guest.userFirstName)) \(String(describing: guest.userLastName))"
        // TODO: imgGuest.image = UIImage(named: "userPlaceholder") 
    }
}
