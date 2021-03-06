//
//  CollectionCell.swift
//  Ecommerce
//
//  Created by Brendan Milton on 20/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    categoryImg.layer.cornerRadius = 5
        
    }
    
    func configureCell(category: Category) {
        categoryLabel.text = category.name
        if let url = URL(string: category.imgURL){
            categoryImg.kf.setImage(with: url)
        }
        
    }

}
