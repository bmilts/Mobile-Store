//
//  CheckoutVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 29/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions
import FirebaseFirestore

class CheckoutVC: UIViewController, CartCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shipMethodButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var paymentContext: STPPaymentContext!
    var weight = StripeCart.itemsWeight
    
    // Testing update sold item functionality
    // var itemIds = StripeCart.itemIds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
        setUpPaymentInfo()
        setupStripeConfig()
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
    
    func productRemoved(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setUpPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
    }
    
    func productPurchased(product: Product) {
        StripeCart.itemSold(item: product)
    }
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.createCardSources = true
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        // Created customer context
        // Invokes cloud function
        // Generates ephemeral key
        // Gets any pre used customer stripe information
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        // Payment context
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }

    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingButtonClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    
}

extension CheckoutVC : STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        // Updating the selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
        // Updating the selected shipping method
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shipMethodButton.setTitle(shippingMethod.label, for: .normal)
            
            // Convert NSNumber from stripe to a double then * 100 to get int dollar value from pennies
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setUpPaymentInfo()
        } else {
            shipMethodButton.setTitle("Select Method", for: .normal)
        }
        
    }
    
    // Error handling
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let idemPotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        // Data for cloud function
        let data : [String: Any] = [
            "total": StripeCart.total,
            "customerId": UserService.user.stripeId,
            "idemPotency": idemPotency
        ]
        
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", message: "Unable to make charge.")
                completion(error)
                return
            }
            
            // Successful payment
            StripeCart.clearCart()
            self.setUpPaymentInfo()
            completion(nil)
        }
    }
    
    // TODO
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        
        activityIndicator.stopAnimating()
        
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            // productPurchased(product: )
            title = "Success!"
            message = "Thank you for your purchase. Ryan loves you!"
            
            // Update firebase variable
        case .userCancellation:
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shippingCalculator() -> NSDecimalNumber {
        
        var amount: NSDecimalNumber = 0.00
        
        if weight > 0 && weight <= 3.00 {
            amount = 17.45
        } else if weight > 3.00 && weight <= 5.00 {
            amount = 19.85
        } else if weight > 5.00 && weight <= 10.00 {
            amount = 25.85
        } else if weight > 10.00 && weight <= 15.00 {
            amount = 31.85
        } else if weight > 15.00 && weight <= 20.00 {
            amount = 37.85
        } else {
            amount = 45.99
        }
        
        return amount
    }
    
    // Set shipping methods
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let ausPost = PKShippingMethod()
        ausPost.label = "Australia Post"
        ausPost.detail = "Austrailia wide arrives 3-7 days"
        ausPost.identifier = "aus_post"
        ausPost.amount = shippingCalculator()
        
        
        let ryanDer = PKShippingMethod()
        ryanDer.amount = 0.00
        ryanDer.label = "Pick up from Ryan"
        ryanDer.detail = "Organise to pick up!"
        ryanDer.identifier = "ryan_der"
        
        // Shipping method for delivering physical goods
        let upsGround = PKShippingMethod()
        upsGround.amount = 40.00
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-7 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 30.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives 7-10 days"
        fedEx.identifier = "fedex"
        
        let royalMail = PKShippingMethod()
        royalMail.amount = 6.99
        royalMail.label = "Royal Mail"
        royalMail.detail = "UK wide arrives 3-7 days"
        royalMail.identifier = "royal_mail"
        
        // Add free pickup if local in sydney australia
        
        // add calculated amount based on shipping
        
        // Calculated amount for US, AU 
        
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedEx], fedEx)
        } else if address.country == "AU" {
            completion(.valid, nil, [ryanDer], ryanDer)
        } else if address.country == "GB" {
            completion(.valid, nil, [royalMail], royalMail)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    
    }
    
}

extension CheckoutVC : UITableViewDelegate, UITableViewDataSource {
    
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
