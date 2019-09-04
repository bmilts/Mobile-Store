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
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
        setUpTableView()
        setUpInitialAnonymousUser()
    }
    
    // Set up navigation in code
    //    func setUpNavigationBar() {
    //        let swiftColor = UIColor(red: 243, green: 242, blue: 247, alpha: 1)
    //        guard let font = UIFont(name: "futura", size: 26) else { return }
    //
    //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: swiftColor, NSAttributedString.Key.font: font]
    //    }
    
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CategoryTVCell, bundle: nil), forCellReuseIdentifier: Identifiers.CategoryTVCell)
    }
    
    func setUpInitialAnonymousUser() {
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
    }
    
    func setCategoriesListener() {
        
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                // Access to document changes
                let data = change.document.data()
                let category = Category.init(data: data)
               
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setCategoriesListener()
        // Check user
        if let user =  Auth.auth().currentUser , !user.isAnonymous {
            // If user/ Logged in
            loginOutBtn.title = "Logout"
            if UserService.userListener == nil {
                // Start checking for user favorites
                UserService.getCurrentUser()
            }
        } else {
            loginOutBtn.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Remove listener when app not in operation to save firestore data
        listener.remove()
        categories.removeAll()
        tableView.reloadData()
    }

    
    fileprivate func presentLoginController() {
        // Load login storyboard
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cartClicked(_ sender: Any) {
        
        if UserService.isGuest {
            simpleAlert(title: "Hello from Ryan!", message: "Please register/login to visit the checkout.")
            return
        }
        
        performSegue(withIdentifier: Segues.HomeToCheckout, sender: self)
    }
    
    @IBAction func favoritesClicked(_ sender: Any) {
        
        if UserService.isGuest {
            simpleAlert(title: "Hello from Ryan!", message: "Please register/login to visit the favorites page.")
            return
        }
        
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
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
                UserService.logoutUser()
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
    
    // DOCUMENT CHANGE FUNCTIONS
       func onDocumentAdded(change: DocumentChange, category: Category){
           let newIndex = Int(change.newIndex)
           categories.insert(category, at: newIndex)
           tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
       }
       
       func onDocumentModified(change: DocumentChange, category: Category){
           if change.newIndex == change.oldIndex {
               // Item changed but remained in same position
               let index = Int(change.newIndex)
               categories[index] = category
               tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
           } else {
               // Item changed and changed position
               let oldIndex = Int(change.oldIndex)
               let newIndex = Int(change.newIndex)
               
               categories.remove(at: oldIndex)
               categories.insert(category, at: newIndex)
               
               tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
           }
           
       }
       
       func onDocumentRemoved(change: DocumentChange){
           
           let oldIndex = Int(change.oldIndex)
           
           categories.remove(at: oldIndex)
           tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .fade)
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CategoryTVCell, for: indexPath) as? CategoryTVCell {
            
            cell.configureCell(category: categories[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                
                // Send category to destination VC or ProductsVC
                destination.category = selectedCategory
            }
        } else if segue.identifier == Segues.ToFavorites {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
    
}

// REFERENCE: Initial code for retrieving from firestore

    // Fetch from firestore
//    func fetchDocument(){
//
//        // Date Reference to root database
//        let docRef = db.collection("categories").document("JsWhLjBn6mhgh9Zqzn3Q")
//
//        // Add listener to single document for data changes
//        docRef.addSnapshotListener { (snap, error) in
//
//            self.categories.removeAll()
//
//            guard let data = snap?.data() else { return }
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.tableView.reloadData()
//        }
        
//        docRef.getDocument { (snap, error) in
//
//            // Category data properties
//            guard let data = snap?.data() else { return }
//
//            let newCategory = Category.init(data: data)
//
//            self.categories.append(newCategory)
//            self.tableView.reloadData()
//        }
        
    //}
    
    // Fetch all categories in firestore database
    // func fetchCollection(){
//        let collectionRef = db.collection("categories")
//
//        listener = collectionRef.addSnapshotListener { (snap, error) in
//
//            guard let documents = snap?.documents else { return }
//
//            print(snap?.documentChanges.count)
//
//            self.categories.removeAll()
//
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//
//            }
//
//            self.tableView.reloadData()
//
//        }
        
//        collectionRef.getDocuments { (snap, error) in
//            guard let documents = snap?.documents else { return }
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//
//            }
//
//            self.tableView.reloadData()
//        }
    // }

// REFERENCE : Initial collection view extension code kept for reference

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
