//
//  MHPHomeViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let reuseIdentifier = "homeCell"
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // TODO: set up static events, remove for production
        let user1 = User(userID: "abcd")
        let event1 = Event(eventID: "12345", eventName: "Potluck Test 1", eventDate: Date(), eventLocation: "Nowhere", eventDescription: "Just testing out some things like this is a thing and that is a thing and wow, things.", eventHostID: user1, eventItemList: EventItemList(), eventRsvpList: EventRsvpList())
        let user2 = User(userID: "abcd")
        let event2 = Event(eventID: "67890", eventName: "Potluck Test 2", eventDate: Date(), eventLocation: "Somewhere", eventDescription: "Second time just testing out some things like this is a thing and that is a thing and wow, things.", eventHostID: user2, eventItemList: EventItemList(), eventRsvpList: EventRsvpList())
        events.append(event1)
        events.append(event2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MHPHomeCollectionViewCell
        cell.eventName = events[indexPath.row].eventName
        cell.eventHost = events[indexPath.row].eventHostID?.userName
        let timeNow = events[indexPath.row].eventDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.eventDateTime = dateFormatter.string(from: timeNow!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
