//
//  LoginVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 14/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Firebase 

class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        
        // Present modal controller
        let forgotPassVC = ForgotPasswordVC()
        forgotPassVC.modalTransitionStyle = .crossDissolve
        forgotPassVC.modalPresentationStyle = .overCurrentContext
        present(forgotPassVC, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let email = emailText.text , email.isNotEmpty ,
            let password = passText.text , password.isNotEmpty else  {
                
                simpleAlert(title: "Error", message: "Please fill out all fields.")
                return
            
        }
    
        activityIndicator.startAnimating()

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
    
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            // Dismiss view controller
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
