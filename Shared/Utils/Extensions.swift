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
