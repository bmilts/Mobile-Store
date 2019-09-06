//
//  Constants.swift
//  Ecommerce
//
//  Created by Brendan Milton on 21/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let Heart = "heart"
    static let FilledHeart = "heartf"
    static let Placeholder = "Placeholder"
    static let Sent = "sent"
}

struct AppColors {
    static let Color1 = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
    static let Color2 = #colorLiteral(red: 0.9620640874, green: 0.6672180295, blue: 0.5050023794, alpha: 1)
    static let Color3 = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
}

// Cell reuse identifiers
// Nibs etc
struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let CategoryTVCell = "CategoryTVCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
    static let HomeToCheckout = "HomeToCheckout"
    static let ProductToCheckout = "ProductToCheckout"
}

