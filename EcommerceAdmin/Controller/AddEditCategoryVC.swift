//
//  AddEditCategoryVC.swift
//  EcommerceAdmin
//
//  Created by Brendan Milton on 25/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    
    var categoryToEdit: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Handle image picker (Create tap recognizer and assign to image)
        
        // Touch gesture recognizer for image clicked
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        // If editing, categoryToEdit will not equal nil
        if let category = categoryToEdit {
            nameText.text = category.name
            addButton.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl){
                categoryImage.contentMode = .scaleAspectFill
                categoryImage.kf.setImage(with: url)
            }
        }
    }
    
    // 3. Need selector functions
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        // Launch image picker
        launchImagePicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
         
        // Check fields are not null
        guard let image = categoryImage.image ,
            let categoryName = nameText.text , categoryName.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please add category image and name")
                return
        }
        
        activityIndicator.startAnimating()
        
        // Step 1: Turn the image into data and compress image
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create a storage image reference -> A location in Firestorage for to store
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
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
        var category = Category.init(name: nameText.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            // Editing (point to existing id)
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            // New category (create new)
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.modelToData(category: category)
        
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

// 2. Launch and pick image

// Launch image picker
extension AddEditCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Uncropped image selected by user
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
