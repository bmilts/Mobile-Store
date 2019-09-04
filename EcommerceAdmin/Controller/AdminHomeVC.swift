//
//  ViewController.swift
//  EcommerceAdmin
//
//  Created by Brendan Milton on 11/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import FirebaseAuth

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpAdminUser()
        // Block Login button
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        // Initialize and add right bar button item
        let addCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryButton
        
    }
    
    @objc func addCategory() {
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }
    
    func setUpAdminUser() {
            // Sign in admin
        Auth.auth().signIn(withEmail: "ryanpder@gmail.com", password: "Test1234") { user, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
        }
    }
}

