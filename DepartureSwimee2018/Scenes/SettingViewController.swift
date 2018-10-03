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
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        
        didSet {
            
            passwordTextField.addBorderBottom(1.0)
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var repasswordTextField: UITextField! {
        
        didSet {
            
            repasswordTextField.addBorderBottom(1.0)
            repasswordTextField.delegate = self
        }
    }
    
    var refresh: UIActivityIndicatorView?
    
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
            iconImageView.kf.setImage(with: FirebaseManager.shared.photoURL, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
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
    
    @IBAction func tapChangeImageButton() {
        
        let _ = UIAlertController(title: "画像を変更する", message: "変更する方法を選択してください。", preferredStyle: .actionSheet)
            .addAction(title: "カメラ", style: .default, handler: { [unowned self] _ in
                
                self.presentPickerController(sourceType: .camera)
            })
            .addAction(title: "アルバム", style: .default, handler: { [unowned self] _ in
                
                self.presentPickerController(sourceType: .photoLibrary)
            })
            .addAction(title: "キャンセル", style: .cancel, handler: nil)
            .show()
    }
    
    private func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
}

extension SettingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as? UIImage
        refresh = UIActivityIndicatorView()
        refresh?.style = .gray
        refresh?.center = self.view.center
        refresh?.startAnimating()
        view.addSubview(refresh!)
        FirebaseManager.shared.updateUserInfo(photo: image, {}, { [unowned self] url in
            
            self.refresh?.stopAnimating()
            self.refresh?.removeFromSuperview()
            self.iconImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
        })
    }
}

extension SettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
