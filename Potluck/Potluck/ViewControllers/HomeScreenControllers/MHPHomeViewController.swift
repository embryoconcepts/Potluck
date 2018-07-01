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
 import SVProgressHUD
 
 class MHPHomeViewController: UIViewController {
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lblAlertMessage: UILabel!
    
    var mhpUser: MHPUser?
    var events = [MHPEvent]()
    lazy var request: MHPRequestHandler = {
        return MHPRequestHandler()
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        self.carousel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleUser()
//        setupMockData() // TODO: remove for production
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
        if segue.identifier == "HomeToEventSegue" {
            if  let user = mhpUser,
                let indexPath = self.carousel.indexPath(for: sender as! MHPHomeCarouselViewCell),
                let eventDetailVC = segue.destination as? MHPEventViewController {
                eventDetailVC.inject((injectedUser: user, injectedEvent: events[indexPath.row]))
            }
        } else {
            // error handling
        }
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func alertTapped(_ sender: Any) {
        if let signinVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") as? MHPSignUpLoginChoiceViewController, let user = mhpUser {
            let navController = UINavigationController(rootViewController: signinVC)
            signinVC.inject(user)
            signinVC.homeUserDelegate = self
            present(navController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func styleView() {
        self.tabBarController?.tabBar.isHidden = false
        self.lblTitle.text = "Welcome to Potluck!"
        
        switch self.mhpUser!.userState {
        case .registered:
            self.viewAlert.isHidden = true
            self.lblAlertMessage.text = ""
            if let firstName = self.mhpUser!.userFirstName, let lastName = self.mhpUser!.userLastName {
                self.lblTitle.text = "Welcome, \(firstName) \(lastName)!"
            }
        case .verified:
            self.viewAlert.isHidden = false
            self.lblAlertMessage.text = "Please complete signup to use all features."
        case .unverified:
            self.viewAlert.isHidden = false
            self.lblAlertMessage.text = "Please verify your email to complete sign up."
        case .anonymous:
            self.viewAlert.isHidden = true
            self.lblAlertMessage.text = ""
        default:
            return
        }
    }
    
    fileprivate func setupMockData() {
        mhpUser = MHPUser()
        mhpUser!.userFirstName = "Tester the Bester"
        var host1 = MHPUser()
        host1.userFirstName = "Jill of AllTrades"
        host1.userID = "host1userID"
        let event1 = MHPEvent(eventID: "event1eventID",
                             eventName: "Potluck Test 1",
                             eventDate: "1/25/2025",
                             eventLocation: "Nowhere",
                             eventAddress: "123 Elm Grove",
                             eventDescription: "Just testing out some things like this is a thing and that is a thing and wow, things.",
                             eventImageURL: "url for event image",
                             eventRestrictions: ["vegan", "kosher", "no nuts"],
                             eventHostID: "host1userID",
                             eventItemListID: "event1eventItemListID",
                             eventRsvpListID: "event1eventRsvpListID")
        
        var host2 = MHPUser()
        host2.userFirstName = "Mary Contrary"
        host2.userID = "host2userID"
        let event2 = MHPEvent(eventID: "event2eventID",
                              eventName: "Potluck Test 2",
                              eventDate: "10/28/2018",
                              eventLocation: "Somewhere",
                              eventAddress: "123 Elm Grove",
                              eventDescription:  "Happy Holidays, everyone! Please join us for our friends and family potluck this year. The theme is “we are all family”, so please bring something that is traditional to you!",
                              eventImageURL: "url for event image",
                              eventRestrictions: ["vegetarian"],
                              eventHostID: "event2eventHostID",
                              eventItemListID: "event2eventItemListID",
                              eventRsvpListID: "event2eventRsvpListID")
        events.append(event1)
        events.append(event2)
    }
    
 }
 
 
 // MARK: UICollectionViewDataSource
 
 extension MHPHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return events.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! MHPHomeCarouselViewCell
            eventCell.setupEventCell(for: events[indexPath.row])
            eventCell.setNeedsLayout()
            eventCell.layoutIfNeeded()
            return eventCell
        default:
            let createCell = collectionView.dequeueReusableCell(withReuseIdentifier: "createCell", for: indexPath) as! MHPCreateEventCell
            createCell.setupCreateEventCell()
            createCell.setNeedsLayout()
            createCell.layoutIfNeeded()
            return createCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if let user = self.mhpUser, let createEventVC = tabBarController?.childViewControllers[1].childViewControllers[0] as? MHPCreateEvent1DetailsViewController {
                createEventVC.inject(user)
                if let tabBarCon = tabBarController {
                    tabBarCon.selectedIndex = 1
                }
            }
        default:
            return
        }
    }
 }
 
 
 // MARK: - UITabBarControllerDelegate
 
 extension MHPHomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let user = self.mhpUser, let createEventVC = tabBarController.childViewControllers[1].childViewControllers[0] as? MHPCreateEvent1DetailsViewController {
            createEventVC.inject(user)
        } 
        if let user = self.mhpUser, let profileVC = tabBarController.childViewControllers[2].childViewControllers[0] as? MHPProfileViewController {
            profileVC.inject(user)
        }
        if let user = self.mhpUser, let settingsVC = tabBarController.childViewControllers[3].childViewControllers[0] as? MHPSettingsViewController {
            settingsVC.inject(user)
        }
        return true
    }
 }
 
 
 // MARK: - HomeUserDelegate
 
 extension MHPHomeViewController: HomeUserDelegate {
    func updateUser(mhpUser: MHPUser) {
        self.mhpUser = mhpUser
    }
 }
 
 
 // MARK: - Injectable Protocol
 
 extension MHPHomeViewController: Injectable {
    typealias T = MHPUser
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
 }
 
 
 // MARK: - UserHandler Protocol
 
 extension MHPHomeViewController: UserHandler {
    func handleUser() {
        if let tabCon = tabBarController, let tabItems = tabCon.tabBar.items {
            SVProgressHUD.show()
            // disable the tabs while retrieving the user to prevent issues with nil value upon loading child VCs
            for t in tabItems {
                t.isEnabled = false
            }
            request.getUser { (result) in
                switch result {
                case .success(let user):
                    self.mhpUser = user
                    self.assertDependencies()
                    self.styleView()
                case .failure(let error):
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                SVProgressHUD.dismiss()
                // enable tabs after completion
                for t in tabItems {
                    t.isEnabled = true
                }
            }
        }
    }
 }
