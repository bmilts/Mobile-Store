//
//  Product.swift
//  Ecommerce
//
//  Created by Brendan Milton on 19/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timeStamp: Timestamp
    var sold: Bool = false
    var weight: Double
    
    // Default initializer 
    init(name: String,
        id: String,
        category: String,
        price: Double,
        productDescription: String,
        imageUrl: String,
        timeStamp: Timestamp,
        sold: Bool = false,
        weight: Double
        ) {
        
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imageUrl
        self.timeStamp = timeStamp
        self.sold = sold
        self.weight = weight
    }
    
    init(data: [String : Any]) {
        
        // Parse firestore data
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.sold = data["sold"] as? Bool ?? false
        self.weight = data["weight"] as? Double ?? 0.0
    }
    
    
    // Convert JSON data model to key value pair for firestore
    static func modelToData(product: Product) -> [String: Any] {
          let data : [String: Any] = [
              "name": product.name,
              "id": product.id,
              "category": product.category,
              "price": product.price,
              "productDescription": product.productDescription,
              "imageUrl": product.imageUrl,
              "timeStamp": product.timeStamp,
              "sold": product.sold,
              "weight": product.weight,
          ]
          
          return data
      }
}

extension Product : Equatable {
    
    // Is left hand side product equal to right hand side product based on criteria
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
