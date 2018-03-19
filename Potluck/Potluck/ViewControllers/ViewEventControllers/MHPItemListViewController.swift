//
//  MHPItemListViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/19/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPItemListViewController: MHPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        // TODO: handle moving to rsvp
        // TODO: handle moving to item card
    }

    
    // MARK: - Action Handlers
    
    @IBAction func rsvpTapped(_ sender: Any) {
        goToRsvp()
    }
}

