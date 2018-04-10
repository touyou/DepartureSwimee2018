//
//  LoginViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField! {
        
        didSet {
            
            userNameTextField.delegate = self
            userNameTextField.cornerRadius = userNameTextField.bounds.height / 2
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        
        didSet {
            
            passwordTextField.delegate = self
            passwordTextField.cornerRadius = passwordTextField.bounds.height / 2
        }
    }
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func tapLoginButton(_ sender: LoadingButton) {
        
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
        
        /// 卒業メンターのメルアドは固定
        /// https://docs.google.com/spreadsheets/d/1p8oYTyV2CZd30ngzIMb7By9xYAge5Lg5j0VF869O84E/edit?usp=sharing
        /// 現役メンターは自分のメルアドで認証してもらう
        sender.startLoading(sender.center)
        Auth.auth().signIn(withEmail: email, password: password, completion: { [unowned self] user, error in
            
            print(user?.email ?? "not found")
            print(error ?? "")
            if error == nil {
                
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
    
    @IBAction func tapRegisterButton() {

        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            
            return
        }
        
        guard let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            
            return
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            
            return
        }
        
        let keyboardSize = keyboardInfo.cgRectValue.size
        loginButtonTopConstraint.constant = keyboardSize.height
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardHide(_ notification: Notification) {
        
        loginButtonTopConstraint.constant = 10
        UIView.animate(withDuration: 0.4, animations: { [unowned self] in
            
            self.view.layoutIfNeeded()
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
