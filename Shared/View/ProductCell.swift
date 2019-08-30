//
//  ProductCell.swift
//  Ecommerce
//
//  Created by Brendan Milton on 19/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Kingfisher

// Protocol (Boss) delegates tasks to delegate (Employee)
// Product cell is boss
// Favorite button is delegate (told to do something)
protocol ProductCellDelegate : class {
    func productFavorited(product: Product)
    
    // Add method to add to cart
    func productAddedToCart(product: Product)
}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate : ProductCellDelegate?
    private var product : Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product, delegate : ProductCellDelegate){
        
        self.product = product
        self.delegate = delegate
        
        productTitle.text = product.name
        // productPrice.text = product.price
        if let url = URL(string: product.imageUrl){
            let placeHolder = UIImage(named: AppImages.Placeholder)
            productImg.kf.indicatorType = .activity
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.setImage(with: url, placeholder: placeHolder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if UserService.favorites.contains(product) {
            favoriteBtn.setImage(UIImage(named: AppImages.FilledHeart), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: AppImages.Heart), for: .normal)
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        delegate?.productAddedToCart(product: product)
        // Disable button click while item is in cart
    }
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
}
