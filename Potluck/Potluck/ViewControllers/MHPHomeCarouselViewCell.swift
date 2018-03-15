//
//  MHPHomeCarouselViewCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/12/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import ScalingCarousel

class MHPHomeCarouselViewCell: ScalingCarouselCell {
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    override func scale(withCarouselInset carouselInset: CGFloat, scaleMinimum: CGFloat) {
        mainView.layer.cornerRadius = 5
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.25
        mainView.layer.shadowOffset = CGSize(width: 3, height: 3)
        mainView.layer.shadowRadius = 3
    }
}

