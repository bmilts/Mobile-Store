//
//  ProductsVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 19/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Firebase

// Product VC is saying yes I will be delegate
class ProductsVC: UIViewController, ProductCellDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    var showFavorites = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        setUpTableView()
        setProductListener()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }
    
    func setProductListener() {
        
        var ref: Query!
        if showFavorites {
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
        } else {
            ref = db.products(category: category.id)
        }
        
        listener = ref.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                           
               // Access to document changes
                let data = change.document.data()
                let product = Product.init(data: data)
              
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
           })
        })
    }
    
    func productFavorited(product: Product) {
        
        if UserService.isGuest {
            simpleAlert(title: "Error", message: "Please register/login to favorite a product.")
        } else {
            UserService.favoriteSelected(product: product)
            guard let index = products.firstIndex(of: product) else { return }
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
    }
    
    // Make product unavailable if in cart
    func productAddedToCart(product: Product) {
        
        if UserService.isGuest {
            simpleAlert(title: "Error", message: "Please register/login to add a product to cart.")
        } else {
            StripeCart.addItemToCart(item: product)
//            guard let index = products.firstIndex(of: product) else { return }
//            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    // DOCUMENT CHANGE FUNCTIONS
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        if change.oldIndex == change.newIndex {
            // Item changed but remained in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .fade)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        
        return UITableViewCell()
    }
    
    // Send data through VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectProduct = products[indexPath.row]
        vc.product = selectProduct
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


