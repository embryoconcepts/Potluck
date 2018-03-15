//
//  MHPSettingsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPSettingsViewController: UIViewController {

    @IBOutlet weak var btnLogInOut: UIButton!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: get user data
        
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
    @IBAction func logInOutTapped(_ sender: Any) {
        // TODO: if user is logged in, then switch button text to Log Out, else button text = Sign Up or Login
       
        if let signUpLoginVC = storyboard?.instantiateViewController(withIdentifier: "SignUpLoginChoiceVC") {
            present(signUpLoginVC, animated: true)
        }
        
    }
    
}
