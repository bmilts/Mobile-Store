//
//  ViewController.swift
//  Ecommerce
//
//  Created by Brendan Milton on 11/07/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Load login storyboard
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }

    // Colour scheme
    // TEXT - #292929
    // Background - #f5f0ea
    // Off White - #F3F2F7
    
}

