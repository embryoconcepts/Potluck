//
//  MHPGuestListViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/19/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPGuestListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRSVP: UIButton!

    typealias T = (injectedUser: MHPUser, injectedEvent: MHPEvent)
    var user: MHPUser?
    var event: MHPEvent?
    var guestsYes = [MHPRsvp]()
    var guestsNo = [MHPRsvp]()
    var guestsInvited = [MHPRsvp]()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        countRsvps()
        assertDependencies()
        // Do any additional setup after loading the view.
        self.title = event?.title ?? "Title"
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        // handle moving to rsvp
    }


    // MARK: - Action Handlers

    @IBAction func rsvpTapped(_ sender: Any) {
        if let rsvpVC = self.storyboard?.instantiateViewController(withIdentifier: "rsvpVC") {
            present(rsvpVC, animated: true, completion: nil)
        }
    }


    // MARK: - Private Methods

    fileprivate func countRsvps() {
        if let tempRsvps = event?.rsvpList?.rsvps {
            for rsvp in tempRsvps {
                if let response = rsvp.response {
                    switch response {
                    case "yes":
                        guestsYes.append(rsvp)
                    case "no":
                        guestsNo.append(rsvp)
                    default:
                        guestsInvited.append(rsvp)
                    }
                }
            }
        }
    }
}


// MARK: - UITableViewDataSource and Delegate

extension MHPGuestListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections = 1

        if guestsYes.count >= 1 {
            numOfSections += 1
        }

        if guestsNo.count >= 1 {
            numOfSections += 1
        }
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return guestsYes.count
        case 1:
            return guestsInvited.count
        default:
            return guestsNo.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Attending \(guestsYes.count)"
        case 1:
            return "Invited (not yet responded) \(guestsInvited.count)"
        default:
            return "Not Attending \(guestsNo.count)"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestListCell", for: indexPath) as? MHPGuestListCell else { return UITableViewCell() }
        var sectionGuests = [MHPRsvp]()
        switch indexPath.section {
        case 0:
            sectionGuests = guestsYes
        case 1:
            sectionGuests = guestsInvited
        default:
            sectionGuests = guestsNo
        }

        #warning("// FIXME: look up user and item")
//        cell.lblGuestName.text = sectionGuests[indexPath.row].user?.userFirstName ?? ""
//        cell.lblItem.text = sectionGuests[indexPath.row].item?.itemName ?? ""
        return cell
    }

}


// MARK: - Injectable Protocol

extension MHPGuestListViewController: Injectable {
    func inject(_ data: (injectedUser: MHPUser, injectedEvent: MHPEvent)) {
        user = data.injectedUser
        event = data.injectedEvent
    }

    func assertDependencies() {
        assert(user != nil)
        assert(event != nil)
    }
}
