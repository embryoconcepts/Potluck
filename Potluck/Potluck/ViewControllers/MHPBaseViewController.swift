//
//  MHPBaseViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/16/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sets back button to arrow only, no title
    func setupBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    /// Dismisses current view controller
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Pops to root - SignUp or Login selection view controller
    func returnToSignUpRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// Returns user to their original flow
    func returnToOriginalFlow() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    ///
    func goToRsvp() {
        if let rsvpVC = self.storyboard?.instantiateViewController(withIdentifier: "rsvpVC") {
            present(rsvpVC, animated: true, completion: nil)
        }
    }
}
