//
//  MHPConfirmationScreenViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPConfirmationScreenViewController: MHPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }
    
    // MARK: - Action Handlers
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        returnToOriginalFlow()
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        returnToOriginalFlow()
    }
}
