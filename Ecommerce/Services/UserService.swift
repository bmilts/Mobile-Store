//
//  UserService.swift
//  Ecommerce
//
//  Created by Brendan Milton on 28/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

// Singleton
final class _UserService {
    
    // User information variables
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var faveListener : ListenerRegistration? = nil
    
    // Computed property
    var isGuest : Bool {
        
        guard let authUser = auth.currentUser else {
            return true
        }
        
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        
        guard let authUser = auth.currentUser else { return }
        
        // creating users reference
        let userRef = db.collection("users").document(authUser.uid)
        
        // Any changes on user document reflected on app
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
            print(self.user)
        })
        
        let favsRef = userRef.collection("favorites")
        faveListener = favsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            // Append to favorites array
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        faveListener?.remove()
        faveListener = nil
        user = User()
        favorites.removeAll()
    }
    
    func favoriteSelected(product: Product){
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        
        if favorites.contains(product) {
            // Remove favorite
            favorites.removeAll{ $0 == product }
            favsRef.document(product.id).delete()
        } else {
            // Add favorite
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
        
    }
}
