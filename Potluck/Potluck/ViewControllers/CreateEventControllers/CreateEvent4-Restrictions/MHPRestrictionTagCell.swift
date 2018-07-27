//
//  MHPRestrictionTagCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/25/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPRestrictionTagCell: UICollectionViewCell, Configurable {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCheckPlus: UIImageView!
    @IBOutlet weak var lblNameMaxWidthConstraint: NSLayoutConstraint!
    
    typealias T = MHPEventRestriction
    var model: MHPEventRestriction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithModel(_ model: MHPEventRestriction) {
        lblNameMaxWidthConstraint.constant = UIScreen.main.bounds.width - 136
        lblName.text = model.name
        
        // round corners
        self.layer.cornerRadius = 15
        
        // drop shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.8
        
        if model.isSelected {
            self.backgroundColor = UIColor.init(hexString: "8FD0AC")
            imgCheckPlus.image = UIImage(named: "iconCheck")
        } else {
            self.backgroundColor = UIColor.init(hexString: "DDDDDD")
            imgCheckPlus.image = UIImage(named: "iconPlus")
        }
        
    }
    
}
