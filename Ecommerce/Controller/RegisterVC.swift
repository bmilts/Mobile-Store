//
//  RegisterVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 14/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confPasswordText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confPassCheckImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Access text changes in password fields
        passwordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confPasswordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    
    }
    
    // Function to check text field changes
    @objc func textFieldDidChange(_ textField: UITextField){
        
        // Access text properties of password text
        guard let passText = passwordText.text else { return }
        
        // Hide images if password text is deleted
        if textField == confPasswordText {
            passCheckImg.isHidden = false
            confPassCheckImg.isHidden = false
        } else {
            if passText.isEmpty {
                passCheckImg.isHidden = true
                confPassCheckImg.isHidden = true
                confPasswordText.text = ""
            }
        }
        
        // Check if password text matches conf text to get green check
        if passwordText.text == confPasswordText.text {
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confPassCheckImg.image  = UIImage(named: AppImages.GreenCheck)
        } else {
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confPassCheckImg.image  = UIImage(named: AppImages.RedCheck) 
        }

    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        // Get values from register form
        guard let email = emailText.text , email.isNotEmpty ,
            let username = usernameText.text , username.isNotEmpty ,
            let password = passwordText.text ,  password.isNotEmpty else {
                
                simpleAlert(title: "Error", message: "Please fill out all fields.")
                return
        }
        
        guard let confirmPass = confPasswordText.text , confirmPass == password else {
            simpleAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
        // Get current logged in user
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        // Credentials for anonymous users
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            // Dismiss view controller and go back to main storyboard
            
            self.activityIndicator.stopAnimating()
            // Dismiss view controller
            self.dismiss(animated: true, completion: nil)
        }
        
    }

}
