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
        #warning("// TODO: remove for production")
        setupMockData()
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
            if let firstName = self.mhpUser!.firstName, let lastName = self.mhpUser!.lastName {
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

        carousel.allowsSelection = true
    }

    fileprivate func setupMockData() {
        mhpUser = MHPUser()
        mhpUser!.firstName = "Tester the Bester"
        var host1 = MHPUser()
        host1.firstName = "Jill of AllTrades"
        host1.userID = "host1userID"

        let restrictions1 = [MHPEventRestriction(name: "vegan", isSelected: true),
                             MHPEventRestriction(name: "vegetarian"),
                             MHPEventRestriction(name: "kosher"),
                             MHPEventRestriction(name: "halal", isSelected: true),
                             MHPEventRestriction(name: "gluten-free"),
                             MHPEventRestriction(name: "no nuts"),
                             MHPEventRestriction(name: "no dairy"),
                             MHPEventRestriction(name: "no eggs"),
                             MHPEventRestriction(name: "no meat"),
                             MHPEventRestriction(name: "no fish", isSelected: true),
                             MHPEventRestriction(name: "no shellfish", isSelected: true),
                             MHPEventRestriction(name: "no pork"),
                             MHPEventRestriction(name: "no soy")]

        let requestedItems1 = [MHPRequestedItem(name: "Beans", quantity: 10, quantityType: "servings")]

        let pledgedItems1 = [MHPPledgedItem()]

        let pledgedItemsList1 = MHPEventPledgedItemList(eventID: "event1eventID",
                                                        description: "You could write about a theme, or ask people to bing kid-friendly stuff",
                                                        tags: ["shellfish"],
                                                        items: pledgedItems1)

        let invites1 = [MHPInvite(userFirstName: "Ada", userLastName: "Lovelace", email: "ada@babbage.com"),
                        MHPInvite(userFirstName: "Hedy", userLastName: "Lamarr", email: "hedy@mail.com")]

        let rsvps1 = [MHPRsvp(userID: "host2userID",
                              email: "grace@hooper.com",
                              eventID: "event1eventID",
                              itemID: "hash string for item id",
                              isGuest: true,
                              isHost: false,
                              response: "yes",
                              notificationsOn: true,
                              numOfGuest: 0)]

        let rsvpList1 = MHPEventRsvpList(hostID: host1.userID, rsvps: rsvps1)

        let event1 = MHPEvent(eventID: "event1eventID",
                              title: "Potluck Test 1",
                              date: "1/25/2025",
                              location: "Nowhere",
                              address: "123 Elm Grove",
                              description: "Just testing out some things like this is a thing and that is a thing and wow, things.",
                              imageURL: "url for event image",
                              restrictionDescription: "Some people are allergic to nuts, so please try to keep them out of your dishes. We also have some vegan and kosher guests.",
                              restrictions: restrictions1,
                              host: host1,
                              requestedItems: requestedItems1,
                              pledgedItemList: pledgedItemsList1,
                              invites: invites1,
                              rsvpList: rsvpList1)


        var host2 = MHPUser()
        host2.firstName = "Mary Contrary"
        host2.userID = "host2userID"

        events.append(event1)
    }

 }


 // MARK: UICollectionViewDataSource

 extension MHPHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            guard let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? MHPHomeCarouselViewCell else { return UICollectionViewCell() }
            eventCell.setupEventCell(for: events[indexPath.row])
            eventCell.setNeedsLayout()
            eventCell.layoutIfNeeded()
            return eventCell
        default:
            guard let createCell = collectionView.dequeueReusableCell(withReuseIdentifier: "createCell", for: indexPath) as? MHPCreateEventCell else { return UICollectionViewCell() }
            createCell.setupCreateEventCell()
            createCell.setNeedsLayout()
            createCell.layoutIfNeeded()
            return createCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if let createEventVC = tabBarController?.children[1].children[0] as? MHPCreateEvent1DetailsViewController {
                let event = MHPEvent()
                createEventVC.inject(event)
                if let user = self.mhpUser {
                    createEventVC.inject(user)
                }
                if let tabBarCon = tabBarController {
                    tabBarCon.selectedIndex = 1
                }
            }
        default:
            if  let user = mhpUser,
                let eventDetailVC =  UIStoryboard(name: "ViewEvent", bundle: nil).instantiateViewController(withIdentifier: "MHPEventViewController") as? MHPEventViewController {
                eventDetailVC.inject((injectedUser: user, injectedEvent: events[indexPath.row]))
                navigationController?.pushViewController(eventDetailVC, animated: true)
            }
        }
    }
 }


 // MARK: - UITabBarControllerDelegate

 extension MHPHomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let user = self.mhpUser, let createEventVC = tabBarController.children[1].children[0] as? MHPCreateEvent1DetailsViewController {
            let event = MHPEvent()
            createEventVC.inject(event)
            createEventVC.inject(user)
        }
        if let user = self.mhpUser, let profileVC = tabBarController.children[2].children[0] as? MHPProfileViewController {
            profileVC.inject(user)
        }
        if let user = self.mhpUser, let settingsVC = tabBarController.children[3].children[0] as? MHPSettingsViewController {
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
            request.getUser { result in
                switch result {
                case .success(let user):
                    self.mhpUser = user
                    if let events = self.mhpUser?.events {
                        for event in events {
                            self.request.getEvent(eventID: event, completion: { result in
                                switch result {
                                case .success(let event):
                                    self.events.append(event)
                                case .failure(let error):
                                    DispatchQueue.main.async { [unowned self] in
                                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        alertController.addAction(defaultAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                                self.carousel.reloadData()
                            })
                        }
                    }
                    self.assertDependencies()
                    self.styleView()
                case .failure(let error):
                    DispatchQueue.main.async { [unowned self] in
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
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
