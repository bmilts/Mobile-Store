//
//  ProductsVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 19/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product.init(name: "Bowls", id: "jfldjakl", category: "Ceramics", price: 24.99, productDescription: "What a lovely bowl", imageUrl: "https://images.pexels.com/photos/951334/pexels-photo-951334.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", timeStamp: Timestamp(), stock: 0, favourite: false)

        products.append(product)
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }

}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


