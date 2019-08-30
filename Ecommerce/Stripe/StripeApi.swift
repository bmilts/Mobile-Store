//
//  StripeApi.swift
//  Ecommerce
//
//  Created by Brendan Milton on 30/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

// Pass user stripeId to stripe via cloud function to check. If all is well stripe passes back ephemeral

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    // Create new ephemeral key method to contact and invoke cloud function on back end
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let data = [
            "stripe_version": apiVersion,
            "customer_Id" : UserService.user.stripeId
        ]
        
        // Pass JSON data object to stripe via firebase functions
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(key, nil)
            print(key)
        }
    }
    
    
}
