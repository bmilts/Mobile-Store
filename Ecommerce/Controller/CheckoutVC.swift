//
//  CheckoutVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 29/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit


class CheckoutVC: UIViewController, CartCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shipMethodButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
        setUpPaymentInfo()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }
    
    func setUpPaymentInfo() {
        subtotalLabel.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingLabel.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func productRemoved(product: Product){
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setUpPaymentInfo()
    }

    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    
    @IBAction func shippingButtonClicked(_ sender: Any) {
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
