//
//  MHPCreateEvent1DetailsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEvent1DetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    @IBAction func cancelTappped(_ sender: UIButton) {
        // TODO: alert - do you really wanna?
        dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
        if let tabs = tabBarController?.viewControllers {
            if tabs.count > 0 {
                self.tabBarController?.selectedIndex = 0
            }
        }
    }

    func next() {
        // TODO: save current values to user preferences, move to next screen
    }
}
