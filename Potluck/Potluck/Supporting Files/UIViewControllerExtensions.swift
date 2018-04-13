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

