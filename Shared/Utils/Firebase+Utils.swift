//
//  Firebase+Utils.swift
//  Ecommerce
//
//  Created by Brendan Milton on 15/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

extension Firestore {
    var categories: Query {
        return collection("categories").order(by: "timeStamp", descending: true)
    }
    
    func products(category: String) -> Query {
        return collection("products").whereField("category", isEqualTo: category).whereField("sold", isEqualTo: false).order(by: "timeStamp", descending: true)
    }
    
}

extension Auth {
    
    // User error alerts
    func handleFireAuthError(error: Error, vc: UIViewController){
        
        // Custom class for errrors
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            
            // Create user alert
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            // Create user action
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            // Present view controller action
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email already has an associated account, please chose another email."
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Please pick a stronger password. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
}
