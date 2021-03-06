//
//  RegisterViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet var userNameTextField: UITextField! {
        
        didSet {
            
            userNameTextField.delegate = self
            userNameTextField.cornerRadius = userNameTextField.bounds.height / 2
        }
    }
    @IBOutlet var passwordTextField: UITextField! {
        
        didSet {
            
            passwordTextField.delegate = self
            passwordTextField.cornerRadius = passwordTextField.bounds.height / 2
        }
    }
    @IBOutlet var repasswordTextField: UITextField! {
        
        didSet {
            
            repasswordTextField.delegate = self
            repasswordTextField.cornerRadius = repasswordTextField.bounds.height / 2
        }
    }
    
    @IBOutlet weak var mentorTextField: UITextField! {
        
        didSet {
            
            mentorTextField.delegate = self
            mentorTextField.cornerRadius = mentorTextField.bounds.height / 2
        }
    }
    
    @IBOutlet var registerButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tapRegisterButton(_ sender: LoadingButton) {
        
        guard let email = userNameTextField.text, email != "" else {
            
            let _ = UIAlertController(title: "ユーザー名がありません", message: "ユーザー名を入力してください。", preferredStyle: .alert)
                .addAction(title: "OK")
                .show()
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            
            let _ = UIAlertController(title: "パスワードがありません", message: "パスワードを入力してください。", preferredStyle: .alert)
                .addAction(title: "OK")
                .show()
            return
        }
        
        guard let repassword = repasswordTextField.text, repassword != "" else {
            
            let _ = UIAlertController(title: "パスワードがありません", message: "パスワードをもう一度入力してください。", preferredStyle: .alert)
                .addAction(title: "OK")
                .show()
            return
        }
        
        if password != repassword {
            
            let _ = UIAlertController(title: "パスワードが一致しません", message: "再度同じパスワードを入力してください。", preferredStyle: .alert)
                .addAction(title: "OK")
                .show()
            return
        }
        
        sender.startLoading(sender.center)
        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self] user, error in
            
            if error == nil {
                
                if let text = self.mentorTextField.text, text != "" {

                    let request = user?.user.createProfileChangeRequest()
                    request?.displayName = text
                    request?.commitChanges(completion: nil)
                }
                sender.stopLoading()
                self.dismiss(animated: true, completion: nil)
            } else {
                
                sender.stopLoading()
                let _ = UIAlertController(title: "エラー", message: error!.localizedDescription, preferredStyle: .alert)
                    .addAction(title: "OK")
                    .show()
            }
        })
    }
    
    @IBAction func tapLoginButton() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            
            return
        }
        
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            
            return
        }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            
            return
        }
        
        let keyboardSize = keyboardInfo.cgRectValue.size
        registerButtonTopConstraint.constant = keyboardSize.height
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardHide(_ notification: Notification) {
        
        registerButtonTopConstraint.constant = 10
        UIView.animate(withDuration: 0.4, animations: { [unowned self] in
            
            self.view.layoutIfNeeded()
        })
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
