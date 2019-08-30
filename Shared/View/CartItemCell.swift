//
//  CartItemCell.swift
//  Ecommerce
//
//  Created by Brendan Milton on 29/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Kingfisher

protocol CartCellDelegate : class {
    func productRemoved(product: Product)
}

class CartItemCell: UITableViewCell {
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    weak var delegate : CartCellDelegate?
    private var item : Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImage.layer.cornerRadius = 5
    }
    
    func configureCell(product: Product, delegate: CartCellDelegate) {
        
        self.item = product
        self.delegate = delegate
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLabel.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl){
            productImage.kf.setImage(with: url)
        }
    }

    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.productRemoved(product: item)
    }
    
}
