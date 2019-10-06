//
//  StripeCart.swift
//  Ecommerce
//
//  Created by Brendan Milton on 29/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

let StripeCart = _StripeCart()

final class _StripeCart {
    
    // Stripe variables
    var cartItems = [Product]()
    // var itemIds = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    // Stripe computed property variables for subtotal, processing fees and total
    var subtotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
//    var itemAddId: [String] {
//        var id = ""
//        var itemIds = [String]()
//
//        for item in cartItems {
//            id = item.id
//            itemIds.append(id)
//        }
//
//        return itemIds
//    }
    
    var itemsWeight: Double {
        var weight = 0.0
        
        for item in cartItems {
            let weights = item.weight
            weight += weights
        }
        return weight
    }
    
    var processingFees: Int {
        
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total: Int {
        return subtotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
        // itemIds.append(item.id)
        // print(itemIds)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
            // itemIds.remove(at: index)
            // print(itemIds)
        }
    }
    
    func itemSold(item: Product) {
        
        // Add batch 
        let updateRef = Firestore.firestore().collection("products").document(item.id)
        updateRef.updateData([
            "sold": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func clearCart() {
        cartItems.removeAll()
        // itemIds.removeAll()
    }
    
}
