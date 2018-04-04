//
//  EditViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/04/02.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class EditViewController: UIViewController {

    @IBOutlet weak var messageTextView: UITextView!
    
    var message: Message!
    var opponentUid: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        messageTextView.text = message?.message
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        
        message = Message(fromUser: FirebaseManager.shared.uid, message: messageTextView.text, photoUrl: nil, key: message.key, gradPhotoKey: nil, currentPhotoKey: nil)
        let messageData = try! FirebaseEncoder().encode(message)
        Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).child(message.key).setValue(messageData)
        
        navigationController?.popViewController(animated: true)
    }
}