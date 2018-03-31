//
//  SettingViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class SettingViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Settings"
        navigationController?.setupBarColor()
        tabBarController?.tabBar.tintColor = UIColor.Swimee.tintRed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if FirebaseManager.shared.isLoggedIn {
            
            nameTextField.text = FirebaseManager.shared.loggedInUserName
            iconImageView.kf.setImage(with: FirebaseManager.shared.photoURL)
        } else {
            
            let viewController = UINavigationController(rootViewController: AccountBaseViewController.instantiate())
            viewController.isNavigationBarHidden = true
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapUpdateButton() {
        
        FirebaseManager.shared.updateUserInfo(displayName: nameTextField.text, {})
    }
    
    @IBAction func tapLogoutButton() {
        
        let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
            let viewController = UINavigationController(rootViewController: AccountBaseViewController.instantiate())
            viewController.isNavigationBarHidden = true
            present(viewController, animated: true, completion: nil)
        } catch let error {
            
            print(error)
        }
    }
}
