//
//  MHPRSVPViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/17/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPRSVPViewController: UIViewController {


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


    // MARK: - Action Handlers

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveTapped(_ sender: Any) {

    }
}
