//
//  MHPGuestListCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/19/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPGuestListCell: UITableViewCell {

    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var imgUser: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
