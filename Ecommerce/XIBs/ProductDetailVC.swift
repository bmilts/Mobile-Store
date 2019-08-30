//
//  ProductDetailVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 24/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescLabel: UILabel!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    // Variables
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        productTitleLabel.text = product.name
        productDescLabel.text = product.productDescription
        
        // Set image url using kingfisher
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
        
        // Convert double to string with currency formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPriceLabel.text = price
        }
        
        // Initialize/Add tapGestureRecognizer to see when user clicks on blurred background
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addCartClicked(_ sender: Any) {
        // Add product to cart
        StripeCart.addItemToCart(item: product)
        
        // Then dismiss
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func productDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
