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
    
    func scale(withCarouselInset carouselInset: CGFloat, scaleMinimum: CGFloat) {
        mainView.layer.cornerRadius = 5
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.25
        mainView.layer.shadowOffset = CGSize(width: 3, height: 3)
        mainView.layer.shadowRadius = 3
    }
    
    func setupEventCell(for event: MHPEvent) {        
        self.lblEventName.text = event.eventName ?? ""
        // FIXME: look up event host to get name
//        self.lblHostName.text = "Hosted by: \(event.eventHost?.userFirstName ?? "")"
        self.lblDateTime.text = event.eventDate ?? ""
        
        // TODO: set up proper image handling
        if let url = event.eventImageURL, let tempImage = UIImage(named: url) {
            self.imgEvent.image = tempImage
        }
    }
   
}
