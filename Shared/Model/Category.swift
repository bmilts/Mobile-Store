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
    var imgURL: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
