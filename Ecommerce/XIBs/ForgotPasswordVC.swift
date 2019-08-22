//
//  ForgotPasswordVC.swift
//  Ecommerce
//
//  Created by Brendan Milton on 28/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    // Outlets
    // Label/Textfield/button/button
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Send reset password email based on button

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        
        // Check email text exists
        guard let email = emailText.text , email.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please enter email.")
            return
        }
        
        // Send password reset
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
