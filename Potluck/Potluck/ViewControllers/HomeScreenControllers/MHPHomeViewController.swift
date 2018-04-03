//
//  MHPHomeViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import ScalingCarousel
import Firebase
import FirebaseFirestore

class MHPHomeViewController: MHPBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarControllerDelegate {
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblTitle: UILabel!
    
    private let reuseIdentifier = "homeCell"
    var mhpUser = MHPUser()
    var events = [MHPEvent]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setupUser()
        
    //    setupMockData() // TODO: remove for production
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        if let indexPath = self.carousel.indexPath(for: sender as! MHPHomeCarouselViewCell) {
            if segue.identifier == "HomeToEventSegue" {
                let eventDetailVC = segue.destination as? MHPEventViewController
                eventDetailVC?.inject((injectedUser: mhpUser, injectedEvent:events[indexPath.row]))
            }
        } else {
            // TODO: error handling
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        switch tabBarIndex {
        case 1: // create event
            // TODO: navigate to create event with anon user
            return
        case 2, 3: // profile, settings
            if mhpUser.userState != .registered || Auth.auth().currentUser == nil {
                if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
                    let navController = UINavigationController(rootViewController: signinVC)
                    signinVC.delegate = self
                    signinVC.mhpUser = mhpUser
                    present(navController, animated: true, completion: nil)
                }
            } else {
                // TODO: inject current user to next screen
                
            }
            
        default:
            return
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
        cell.lblHostName.text = "Hosted by: \(selectedEvent.eventHost?.userFirstName ?? "")" 
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
    
    fileprivate func setupUser() {
        let user = Auth.auth().currentUser
        Auth.auth().currentUser?.reload(completion: { (error) in
            if error == nil {
                if let firUser = Auth.auth().currentUser {
                    if firUser.isEmailVerified {
                        UserManager().retrieveMHPUserWith(firUser: firUser) { (result) in
                            switch result {
                            case let .success(user):
                                self.mhpUser = (user as! MHPUser)
                                self.mhpUser.userState = .registered
                                if let firstName = self.mhpUser.userFirstName {
                                    self.lblTitle.text = "Welcome, \(firstName)!"
                                }
                            case .error(_):
                                self.mhpUser.userState = .verified
                                print(DatabaseError.errorRetrievingUserFromDB)
                            }
                        }
                    } else {
                        self.mhpUser.userState = .unverified
                    }
                } else {
                    // TODO: set up anon user
                    self.mhpUser.userState = .unknown
                }
            } else {
                // TODO: handle error
            }
        })
    }
    
    fileprivate func setupMockData() {
        mhpUser = MHPUser()
        mhpUser.userFirstName = "Tester the Bester"
        var host1 = MHPUser()
        host1.userFirstName = "Jill of AllTrades"
        let event1 = MHPEvent(eventID: "12345", eventName: "Potluck Test 1", eventDate: "1/25/2025", eventLocation: "Nowhere", eventDescription: "Just testing out some things like this is a thing and that is a thing and wow, things.", eventImageURL: "url for event image", eventHost: host1, eventItemList: MHPEventItemList(), eventRsvpList: MHPEventRsvpList())
        
        var host2 = MHPUser()
        host2.userFirstName = "Mary Contrary"
        let event2 = MHPEvent(eventID: "67890", eventName: "Potluck Test 2", eventDate: "10/28/2018", eventLocation: "Somewhere", eventDescription: "Happy Holidays, everyone! Please join us for our friends and family potluck this year. The theme is “we are all family”, so please bring something that is traditional to you!", eventImageURL: "url for event image", eventHost: host2, eventItemList: MHPEventItemList(), eventRsvpList: MHPEventRsvpList())
        events.append(event1)
        events.append(event2)
    }
    
}

extension MHPHomeViewController:LoginViewControllerDelegate {
    func didLoginSuccessfully(mhpUser: MHPUser) {
        dismiss(animated: true) {
            self.mhpUser = mhpUser
        }
    }
    
}
