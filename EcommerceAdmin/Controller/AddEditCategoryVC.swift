//
//  AddEditCategoryVC.swift
//  EcommerceAdmin
//
//  Created by Brendan Milton on 25/08/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit

class AddEditCategoryVC: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Touch gesture recognizer for image clicked
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        // Launch image picker
        launchImagePicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
    }
}

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
