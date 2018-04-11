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

class MHPHomeViewController: MHPBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarControllerDelegate, HomeUserDelegate {
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lblAlertMessage: UILabel!
    
    private let reuseIdentifier = "homeCell"
    var mhpUser: MHPUser!
    var events = [MHPEvent]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUser()
        //    setupMockData() // TODO: remove for production
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            // error handling
        }
    }

    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if let createEventVC = tabBarController.childViewControllers[1].childViewControllers[0] as? MHPCreateEvent1DetailsViewController {
                createEventVC.mhpUser = self.mhpUser
            }
            if let profileVC = tabBarController.childViewControllers[2].childViewControllers[0] as? MHPProfileViewController {
                profileVC.inject(self.mhpUser)
            }
            if let settingsVC = tabBarController.childViewControllers[3].childViewControllers[0] as? MHPSettingsViewController {
                settingsVC.inject(self.mhpUser)
            }
        
        return true
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
        // set up page control coordination?
//        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
//        output.text = String(describing: currentCenterIndex)
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func alertTapped(_ sender: Any) {
        if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController {
            let navController = UINavigationController(rootViewController: signinVC)
            signinVC.mhpUser = mhpUser
            signinVC.homeUserDelegate = self
            present(navController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - HomeUserDelegate
    
    func updateUser(mhpUser: MHPUser) {
        self.mhpUser = mhpUser
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func setupUser() {
        UserManager().setupUser { (user) in
            self.mhpUser = user
            self.assertDependencies()
            self.styleView()
        }
    }
    
    fileprivate func styleView() {
        self.tabBarController?.tabBar.isHidden = false
        self.lblTitle.text = "Welcome to Potluck!"
        
        switch self.mhpUser.userState {
        case .registered:
            self.viewAlert.isHidden = true
            self.lblAlertMessage.text = ""
            if let firstName = self.mhpUser.userFirstName, let lastName = self.mhpUser.userLastName {
                self.lblTitle.text = "Welcome, \(firstName) \(lastName)!"
            }
        case .verified:
            self.viewAlert.isHidden = false
            self.lblAlertMessage.text = "Please complete signup to use all features."
        case .unverified:
            self.viewAlert.isHidden = false
            self.lblAlertMessage.text = "Please verify your email to complete sign up."
        case .unknown:
            self.viewAlert.isHidden = true
            self.lblAlertMessage.text = ""
        }
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

extension MHPHomeViewController:UserInjectable {
    typealias T = MHPUser
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
}
