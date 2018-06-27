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

extension String {
    func toDate(format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
}


extension Date {
    func toString(format: String) -> String? {
        
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
    func add(component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
}
