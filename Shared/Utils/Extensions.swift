//
//  Extensions.swift
//  Ecommerce
//
//  Created by Brendan Milton on 16/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//
import UIKit
import Foundation
import Firebase

extension String {
    
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    // Add simple alert for general error checking
    func simpleAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Int {

    func penniesToFormattedCurrency() -> String {
        
        // Stripe currency in pennies example 1234/100 = 12.34
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}
