//
//  ProductCell.swift
//  Ecommerce
//
//  Created by Brendan Milton on 19/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product){
        productTitle.text = product.name
        // productPrice.text = product.price
        if let url = URL(string: product.imageUrl){
                       productImg.kf.setImage(with: url)
                   }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
    }
    @IBAction func favoriteClicked(_ sender: Any) {
    }
}
