//
//  UIViewControllerExtensions.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/16/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Sets back button to arrow only, no title
    func setupBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}

extension UIViewController {
    func presentCancelAlert(view: UIViewController) {
        let alert = UIAlertController(title: "Cancel",
                                      message: "Are you sure you want to cancel? All changes will be lost.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
            
            // return to Home
            self.tabBarController?.tabBar.isHidden = false
            if let tabs = self.tabBarController?.viewControllers {
                if tabs.count > 0 {
                    self.tabBarController?.selectedIndex = 0
                }
            }
            view.dismiss(animated: true, completion: nil)
        }))
        
        view.present(alert, animated: true)
    }
}
