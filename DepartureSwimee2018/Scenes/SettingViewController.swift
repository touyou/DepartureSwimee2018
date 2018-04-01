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
    @IBOutlet weak var nameTextField: UITextField! {
        
        didSet {
            
            nameTextField.addBorderBottom(1.0)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        
        didSet {
            
            nameTextField.addBorderBottom(1.0)
        }
    }
    @IBOutlet weak var repasswordTextField: UITextField! {
        
        didSet {
            
            nameTextField.addBorderBottom(1.0)
        }
    }
    
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
        
        guard let password = passwordTextField.text, password != "" else {
            
            return
        }
        
        guard let repassword = repasswordTextField.text, password == repassword else {
            
            let _ = UIAlertController(title: "パスワードが違います", message: "同じパスワードをもう一度入力してください。", preferredStyle: .alert)
                .addAction(title: "OK")
                .show()
            return
        }
        
        FirebaseManager.shared.updateUserInfo(password: password, { [weak self] in
            
            guard let `self` = self else {
                
                return
            }
            self.passwordTextField.text = ""
            self.repasswordTextField.text = ""
        })
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
