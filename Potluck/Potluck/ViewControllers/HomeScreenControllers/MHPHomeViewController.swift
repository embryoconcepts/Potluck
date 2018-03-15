//
//  MHPHomeViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import ScalingCarousel

class MHPHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let reuseIdentifier = "homeCell"
    var events = [Event]()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: set up static events, remove for production
        let user1 = User(userID: "abcd")
        let event1 = Event(eventID: "12345", eventName: "Potluck Test 1", eventDate: "1/25/2025", eventLocation: "Nowhere", eventDescription: "Just testing out some things like this is a thing and that is a thing and wow, things.", eventImageURL: "url for event image", eventHostID: user1, eventItemList: EventItemList(), eventRsvpList: EventRsvpList())
        let user2 = User(userID: "abcd")
        let event2 = Event(eventID: "67890", eventName: "Potluck Test 2", eventDate: "10/28/2018", eventLocation: "Somewhere", eventDescription: "Happy Holidays, everyone! Please join us for our friends and family potluck this year. The theme is “we are all family”, so please bring something that is traditional to you!", eventImageURL: "url for event image", eventHostID: user2, eventItemList: EventItemList(), eventRsvpList: EventRsvpList())
        events.append(event1)
        events.append(event2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.carousel.indexPath(for: sender as! MHPHomeCarouselViewCell){
            if segue.identifier == "HomeToEventSegue" {
                let selectedEvent = events[indexPath.row]
                let eventDetailVC = segue.destination as! MHPEventViewController
                eventDetailVC.event = selectedEvent
                if let tempUser = user {
                    eventDetailVC.user = tempUser
                }
            }
        } else {
            // TODO: error handling
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MHPHomeCarouselViewCell
        let selectedEvent = events[indexPath.row]
        
        if let tempName = selectedEvent.eventName {
            cell.lblEventName.text = tempName
        }
        if let tempHost = selectedEvent.eventHostID?.userID {
            cell.lblHostName.text = "Hosted by: \(tempHost)"
        }
        if let tempDate = selectedEvent.eventDate {
            cell.lblDateTime.text = tempDate
        }
        
        // TODO: set up proper image handling
        if let tempImage = UIImage(named: selectedEvent.eventImageURL!){
             cell.imgEvent.image = tempImage
        }
       
        return cell
    }
    
    
    // MARK: ScalingCarousel Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
        // TODO: possibly set up page control coordination?
//        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
//        output.text = String(describing: currentCenterIndex)
    }
    
}
