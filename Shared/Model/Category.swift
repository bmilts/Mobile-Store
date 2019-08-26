//
//  Category.swift
//  Ecommerce
//
//  Created by Brendan Milton on 15/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var timeStamp: Timestamp
    
    // Default initializer
    init(
        name: String,
        id: String,
        imgUrl: String,
        isActive: Bool = true,
        timeStamp: Timestamp) {
        
        self.name = name
        self.id = id
        self.imgUrl = imgUrl
        self.isActive = isActive
        self.timeStamp = timeStamp
    }
    
    // Data parsing initializer
    init(data: [String : Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    // Convert JSON data model to key value pair for firestore
    static func modelToData(category: Category) -> [String: Any] {
        let data : [String: Any] = [
            "name": category.name,
            "id": category.id,
            "imgUrl": category.imgUrl,
            "isActive": category.isActive,
            "timeStamp": category.timeStamp
        ]
        
        return data
    }
}
