//
//  AdminProductsVC.swift
//  EcommerceAdmin
//
//  Created by Brendan Milton on 26/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {

    // Keep track of edit or adding product
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Programatically create and add bar buttons
        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductButton = UIBarButtonItem(title: "Add Product", style: .plain, target: self, action: #selector(newProduct))
        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: false)
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @objc func newProduct() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    // Override parent (ProductsVC) implementation of function
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing product (parent variable)
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
        
    }
    
    // Prepare for segue depending on editing category or product
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }

}
