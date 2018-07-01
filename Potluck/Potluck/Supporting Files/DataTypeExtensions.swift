//
//  DataTypeExtensions.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/1/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import MapKit

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

extension CLPlacemark {
    var compactAddress: String? {
        var result = ""
        if let name = name {
            result += "\(name)"
        }
        
        if let street = thoroughfare, let number = subThoroughfare {
            let streetAddress = "\(number) \(street)"
            if result != streetAddress {
                result += ", \(streetAddress)"
            }
        }
        
        if let city = locality {
            result += ", \(city)"
        }
        
        if let state = administrativeArea {
            result += ", \(state)"
        }
        
        if let zip = postalCode {
            result += ", \(zip)"
        }
        return result
    }
    
}
