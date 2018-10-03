//
//  FirebaseManager.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import CodableFirebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    var isLoggedIn: Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    var loggedInUserName: String? {
        
        return Auth.auth().currentUser?.displayName
    }
    
    var loggedInEmail: String? {
        
        return Auth.auth().currentUser?.email
    }
    
    var photoURL: URL? {
        
        return Auth.auth().currentUser?.photoURL
    }
    
    var uid: String {
        
        return Auth.auth().currentUser?.uid ?? "unknown"
    }
    
    var isGrad: Bool {
        
        if let email = loggedInEmail {
            
            let domain = String(email.split(separator: "@").last!)
            return domain == "swimee.com"
        }
        return false
    }
    
    private var timestamp: String {
        
        return String(Date().timeIntervalSince1970 * 100000)
    }
    
    func updateUserInfo(displayName: String? = nil, email: String? = nil, photo: UIImage? = nil, password: String? = nil, _ completion: () -> Void, _ photoCompletion: ((URL?) -> Void)? = nil) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        if let displayName = displayName {
            
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges(completion: { _ in
                
                let me = User(name: FirebaseManager.shared.loggedInUserName, iconUrl: FirebaseManager.shared.photoURL, uid: FirebaseManager.shared.uid)
                let data = try! FirebaseEncoder().encode(me)
                Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "grad" : "current").child(FirebaseManager.shared.uid).setValue(data)
            })
        }
        
        if let email = email {
            
            Auth.auth().currentUser?.updateEmail(to: email, completion: nil)
        }
        
        if let photo = photo {
            
            uploadPhoto(photo, isProfile: true, completion: { url in
                
                changeRequest?.photoURL = url
                changeRequest?.commitChanges(completion: { _ in
                    
                    let me = User(name: FirebaseManager.shared.loggedInUserName, iconUrl: FirebaseManager.shared.photoURL, uid: FirebaseManager.shared.uid)
                    let data = try! FirebaseEncoder().encode(me)
                    Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "grad" : "current").child(FirebaseManager.shared.uid).setValue(data)
                })
                photoCompletion?(url)
            })
        }
        
        if let password = password {
            
            Auth.auth().currentUser?.updatePassword(to: password, completion: nil)
        }
        
        completion()
    }
    
    func uploadPhoto(_ image: UIImage, isProfile: Bool, completion: @escaping (URL?) -> Void) {
        
        let ref = Storage.storage().reference()
        
        if let data = image.pngData() {
            
            let path = "images/\(uid)/" + (isProfile ? "prof/" : "") + timestamp + ".jpg"
            ref.child(path).putData(data, metadata: nil, completion: { _, _ in
                
                ref.child(path).downloadURL(completion: { url, error in
                    
                    if let error = error {
                        
                        print(error)
                    }
                    completion(url)
                })
            })
        }
    }
}
