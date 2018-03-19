//
//  MHPHomeViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import ScalingCarousel

class MHPHomeViewController: MHPBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let reuseIdentifier = "homeCell"
    var user: MHPUser?
    var events = [MHPEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        // TODO: retrieve user data, populate events with user's EventItemList
        
        // TODO: remove for production
        setupMockData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        if let indexPath = self.carousel.indexPath(for: sender as! MHPHomeCarouselViewCell) {
            if segue.identifier == "HomeToEventSegue" {
                let eventDetailVC = segue.destination as? MHPEventViewController
                if let tempUser = user {
                    eventDetailVC?.inject((injectedUser: tempUser, injectedEvent:events[indexPath.row]))
                }
            }
        } else {
            // TODO: error handling
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MHPHomeCarouselViewCell
        let selectedEvent = events[indexPath.row]
        
        cell.lblEventName.text = selectedEvent.eventName ?? ""
        cell.lblHostName.text = "Hosted by: \(selectedEvent.eventHost?.userName ?? "")" 
        cell.lblDateTime.text = selectedEvent.eventDate ?? ""
        
        // TODO: set up proper image handling
        if let tempImage = UIImage(named: selectedEvent.eventImageURL!) {
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
    
    
    // MARK: - Private Methods
    
    fileprivate func setupMockData() {
        user = MHPUser()
        user?.userName = "Tester the Bester"
        var host1 = MHPUser()
        host1.userName = "Jill of AllTrades"
        let event1 = MHPEvent(eventID: "12345", eventName: "Potluck Test 1", eventDate: "1/25/2025", eventLocation: "Nowhere", eventDescription: "Just testing out some things like this is a thing and that is a thing and wow, things.", eventImageURL: "url for event image", eventHost: host1, eventItemList: MHPEventItemList(), eventRsvpList: MHPEventRsvpList())
        
        var host2 = MHPUser()
        host2.userName = "Mary Contrary"
        let event2 = MHPEvent(eventID: "67890", eventName: "Potluck Test 2", eventDate: "10/28/2018", eventLocation: "Somewhere", eventDescription: "Happy Holidays, everyone! Please join us for our friends and family potluck this year. The theme is “we are all family”, so please bring something that is traditional to you!", eventImageURL: "url for event image", eventHost: host2, eventItemList: MHPEventItemList(), eventRsvpList: MHPEventRsvpList())
        events.append(event1)
        events.append(event2)
    }
    
}
