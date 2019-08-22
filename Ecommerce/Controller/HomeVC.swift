//
//  ViewController.swift
//  Ecommerce
//
//  Created by Brendan Milton on 11/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

// Colour scheme
// TEXT - #292929
// Background - #f5f0ea
// Off White - #F3F2F7

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    // 1. Link tableView
    // @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    var categories = [Category]()
    var selectedCategory: Category!
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
        
        // Manual cell for testing
        let category = Category.init(name: "Ceramics", id: "fjdlksaj", imgURL: "https://images.unsplash.com/photo-1554042861-0ad2fc2a8dc2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", timeStamp: Timestamp())
        
        categories.append(category)
    
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 3. Register tableView Nib
        tableView.register(UINib(nibName: Identifiers.CategoryTVCell, bundle: nil), forCellReuseIdentifier: Identifiers.CategoryTVCell)
        
        // User log in check
        if Auth.auth().currentUser == nil {
            
            // Sign in anonymously
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
        
        fetchDocument()
    }
    
    // Fetch from firestore
    func fetchDocument(){
        
        // Date Reference to root database
        let docRef = db.collection("categories").document("JsWhLjBn6mhgh9Zqzn3Q")
        
        docRef.getDocument { (snap, error) in
            
            // Category data properties
            guard let data = snap?.data() else { return }
            let name = data["name"] as? String ?? ""
            let id = data["id"] as? String ?? ""
            let imgUrl = data["imgUrl"] as? String ?? ""
            let isActive = data["isActive"] as? Bool ?? true
            let timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
            
            let newCategory = Category.init(name: name, id: id, imgURL: imgUrl, isActive: isActive, timeStamp: timeStamp)
            
            self.categories.append(newCategory)
            self.tableView.reloadData()
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check user
        if let user =  Auth.auth().currentUser , !user.isAnonymous {
            // If user/ Logged in
            loginOutBtn.title = "Logout"
        } else {
            loginOutBtn.title = "Login"
        }
    }

    
    fileprivate func presentLoginController() {
        // Load login storyboard
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    

    @IBAction func loginOutClicked(_ sender: Any) {
        
        // get user
        guard let user = Auth.auth().currentUser else { return }
        if user .isAnonymous {
            presentLoginController()
        } else {
            // Logged in as email authentication
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
    }
}

// 5. Change Extension methods to tableView methods

//UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
//
//            cell.configureCell(category: categories[indexPath.item])
//            return cell
//        }
//
//        return UICollectionViewCell()
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CategoryTVCell, for: indexPath) as? CategoryTVCell {
            
            cell.configureCell(category: categories[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    // Cell size
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        // Calculate width and height based on screensize
//        let width = view.frame.width
//        let cellWidth = (width - 30) / 2
//        let cellHeight = cellWidth * 1.5
//
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCategory = categories[indexPath.item]
//        performSegue(withIdentifier: Segues.ToProducts, sender: self)
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
        
        // Grey out then stop
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        }
    }
    
}

