//
//  MHPLoginViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPLoginViewController: MHPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTappped(_:)))

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
    
    @IBAction func cancelTappped(_ sender: UIBarButtonItem) {
        returnToSignUpRoot()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        returnToOriginalFlow()
    }
    
}
