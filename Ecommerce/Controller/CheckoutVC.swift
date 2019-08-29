//
//  CheckoutVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 29/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {
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
    }

    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    
    @IBAction func shippingButtonClicked(_ sender: Any) {
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
    }
}
