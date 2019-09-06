//
//  StripeCart.swift
//  Ecommerce
//
//  Created by Brendan Milton on 29/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import Firebase

let StripeCart = _StripeCart()

final class _StripeCart {
    
    // Stripe variables
    var cartItems = [Product]()
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
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
//    func calculateDelivery() {
//
//    }
    
//    func itemSold() {
//        for item in cartItems {
//
//        }
//        
//        let value =
//        let ref = FIRDatabase.database().reference().root.child("users").child(uid).updateChildValues(["Places": values])
//        
//    }
    
    
    func clearCart() {
        cartItems.removeAll()
    }
    
}
