//
//  CategoryTVCell.swift
//  Ecommerce
//
//  Created by Brendan Milton on 20/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryTVCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        categoryImg.layer.cornerRadius = 5
               
               }
            
       func configureCell(category: Category) {
           categoryLabel.text = category.name
           if let url = URL(string: category.imgUrl){

            let placeholder = UIImage(named: "background")
        
            // Fade in options for image
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            
            // Activity indicator
            categoryImg.kf.indicatorType = .activity
            categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
           }

       }

}
