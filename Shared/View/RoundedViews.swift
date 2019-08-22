//
//  RoundedViews.swift
//  Ecommerce
//
//  Created by Brendan Milton on 21/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton : UIButton {
    
    // Method called as class initialized
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }
}

class RoundedShadowView : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.Color1.cgColor
        // 0 = totally transparent 1 = opaque
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }
}
