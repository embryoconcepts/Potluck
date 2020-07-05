//
//  MHPCreateEventCell.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/24/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import ScalingCarousel

class MHPCreateEventCell: ScalingCarouselCell {
    @IBOutlet weak var lblCreateEvent: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!

    func scale(withCarouselInset carouselInset: CGFloat, scaleMinimum: CGFloat) {
        mainView.layer.cornerRadius = 5

        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.25
        mainView.layer.shadowOffset = CGSize(width: 3, height: 3)
        mainView.layer.shadowRadius = 3
    }

    func setupCreateEventCell() {
        if let tempImage = UIImage(named: "image") {
            self.imgEvent.image = tempImage
        }
    }
}
