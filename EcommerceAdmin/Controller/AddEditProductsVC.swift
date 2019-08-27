//
//  AddEditProductsVC.swift
//  EcommerceAdmin
//
//  Created by Brendan Milton on 26/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class AddEditProductsVC: UIViewController {
    
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var productPriceText: UITextField!
    @IBOutlet weak var productDescText: UITextView!
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: RoundedButton!
    
    var selectedCategory: Category!
    var productToEdit: Product?
    
    var productName = ""
    var productPrice = 0.0
    var productDescription = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and add productImage tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tap)
        
        // Check if product is for editing
        if let product = productToEdit {
            productNameText.text = product.name
            productPriceText.text = String(product.price)
            productDescText.text = product.productDescription
            addButton.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: product.imageUrl) {
                productImage.contentMode = .scaleAspectFill
                productImage.kf.setImage(with: url)
            }
        }
        
    }
    
    @objc func imageTapped(){
        launchImagePicker()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
         
        // Check fields are not null
        guard let image = productImage.image ,
            let productName = productNameText.text , productName.isNotEmpty ,
            let priceString = productPriceText.text ,
            let productPrice = Double(priceString) ,
            let productDescription = productDescText.text, productDescription.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please complete all fields.")
                return
        }
        
        self.productName = productName
        self.productPrice = productPrice
        self.productDescription = productDescription
        
        activityIndicator.startAnimating()
        
        // Step 1: Turn the image into data and compress image
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create a storage image reference -> A location in Firestorage for to store
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        
        // Step 3: Set the meta data to assist classification of files
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // Step 4: Upload data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            
            // Step 5: Once the image is uploaded, retrieve the download URL
            imageRef.downloadURL { (url, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image url.")
                    return
                }
                
                guard let url = url else { return }
                
                // Step 6: Upload new category document to the Firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            }

        }
    
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        // Create initializer in product model
        var product = Product.init(name: productName, id: "", category: selectedCategory.id, price: productPrice, productDescription: productDescription, imageUrl: url, timeStamp: Timestamp())
        
        if let productToEdit = productToEdit {
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        
         // Editing or adding brand new category
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            
            // Back to categories
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: msg)
        self.activityIndicator.stopAnimating()
    }
    
}

// 2. Handle image picker
extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        productImage.contentMode = .scaleAspectFill
        productImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
