//
//  MessageViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.register(MessageTableViewHeaderFooterView.self)
            tableView.register(MessageTableViewCell.self)
            tableView.register(ImageTableViewCell.self)
            tableView.register(AddTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
        }
    }
    
    var messages: [Message] = []
    var opponentUid: String!
    var opponent: User?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Message"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if FirebaseManager.shared.isLoggedIn {
            
            let topUid = FirebaseManager.shared.isGrad ? FirebaseManager.shared.uid : opponentUid
            let secondUid = FirebaseManager.shared.isGrad ? opponentUid : FirebaseManager.shared.uid
            Database.database().reference().child("messages").child(topUid!).child(secondUid!).observe(.value, with: { snapshot in
                
                let children = snapshot.children.map { ($0 as! DataSnapshot).value }
                do {
                    
                    self.messages = try FirebaseDecoder().decode([Message].self, from: children)
                    self.tableView.reloadData()
                } catch let error {
                    
                    print(error)
                }
            })
            
            // 相手の名前とかを取得
            Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "current" : "grad").child(opponentUid).observe(.value, with: { snapshot in
                
                guard let value = snapshot.value else { return }
                do {
                    
                    self.opponent = try FirebaseDecoder().decode(User.self, from: value)
                } catch let error {
                    
                    print(error)
                }
            })
        }
    }
    
    deinit {
        
        let topUid = FirebaseManager.shared.isGrad ? FirebaseManager.shared.uid : opponentUid
        let secondUid = FirebaseManager.shared.isGrad ? opponentUid : FirebaseManager.shared.uid
        Database.database().reference().child("messages").child(topUid!).child(secondUid!).removeAllObservers()
        Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "current" : "grad").child(opponentUid).removeAllObservers()
    }
    
    private func presentPickerController(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count + (FirebaseManager.shared.isGrad ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < messages.count {
            
            if let message = messages[indexPath.row].message {
                
                let cell: MessageTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.messageLabel.text = message
                return cell
            }
            
            if let photoUrl = messages[indexPath.row].photoUrl {
                
                let cell: ImageTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.mainImageView.kf.setImage(with: photoUrl, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
                return cell
            }
        } else if !FirebaseManager.shared.isGrad {
            
            let cell: AddTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.action = { [weak self] in
                
                guard let `self` = self else { return }
                let _ = UIAlertController(title: "メッセージの追加", message: "追加するものを選んでください。", preferredStyle: .actionSheet)
                    .addAction(title: "メッセージ", style: .default, handler: { _ in
                        
                        let alert = UIAlertController(title: "メッセージ", message: "メッセージを入力してください。", preferredStyle: .alert)
                            .addAction(title: "キャンセル", style: .cancel, handler: nil)
                        
                        let action = UIAlertAction(title: "追加", style: .default, handler: { _ in
                            
                            guard let textFields = alert.textFields,
                                let textField = textFields.first else { return }
                            
                            let key = Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).childByAutoId().key
                            let message = Message(fromUser: FirebaseManager.shared.uid, message: textField.text, photoUrl: nil, key: key, gradPhotoKey: nil, currentPhotoKey: nil)
                            let messageData = try! FirebaseEncoder().encode(message)
                            
                            Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).child(key).setValue(messageData)
                        })
                        alert.addAction(action)
                        alert.addTextField(configurationHandler: nil)
                        alert.show()
                    })
                    .addAction(title: "写真", style: .default, handler: { _ in
                        
                        let _ = UIAlertController(title: "写真を選択", message: "写真の洗濯方法を選んでください。", preferredStyle: .actionSheet)
                            .addAction(title: "カメラ", style: .default, handler: { _ in
                                
                                self.presentPickerController(sourceType: .camera)
                            })
                            .addAction(title: "アルバム", style: .default, handler: { _ in
                                
                                self.presentPickerController(sourceType: .photoLibrary)
                            })
                            .addAction(title: "キャンセル", style: .cancel, handler: nil)
                            .show()
                    })
                    .addAction(title: "キャンセル", style: .cancel, handler: nil)
                    .show()
            }
            return cell
        }
        
        return UITableViewCell()
    }
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header: MessageTableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView()
        header.iconImageView.kf.setImage(with: opponent?.iconUrl, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
        header.nameLabel.text = opponent?.name
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 116.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if FirebaseManager.shared.isGrad { return }
        
        if editingStyle == .delete {
            
            let topUid = FirebaseManager.shared.isGrad ? FirebaseManager.shared.uid : opponentUid
            let secondUid = FirebaseManager.shared.isGrad ? opponentUid : FirebaseManager.shared.uid
            Database.database().reference().child("messages").child(topUid!).child(secondUid!).child(messages[indexPath.row].key).removeValue()
            if let gradKey = messages[indexPath.row].gradPhotoKey,
                let currentKey = messages[indexPath.row].currentPhotoKey {
                
                Database.database().reference().child("photos").child("grad").child(opponentUid).child(gradKey).removeValue()
                Database.database().reference().child("photos").child("current").child(FirebaseManager.shared.uid).child(currentKey).removeValue()
            }
        }
    }
}

extension MessageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        FirebaseManager.shared.uploadPhoto(image, isProfile: false, completion: { [unowned self] url in
            
            // メッセージとしてのデータ
            let key = Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).childByAutoId().key
            let gradKey = Database.database().reference().child("photos").child("grad").child(self.opponentUid).childByAutoId().key
            let currentKey = Database.database().reference().child("photos").child("current").child(FirebaseManager.shared.uid).childByAutoId().key
            let message = Message(fromUser: FirebaseManager.shared.uid, message: nil, photoUrl: url, key: key, gradPhotoKey: gradKey, currentPhotoKey: currentKey)
            let messageData = try! FirebaseEncoder().encode(message)
            
            Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).child(key).setValue(messageData)
            
            // 写真一覧としてのデータ
            let photo = Photo(url: url)
            let photoData = try! FirebaseEncoder().encode(photo)
            
            Database.database().reference().child("photos").child("grad").child(self.opponentUid).child(gradKey).setValue(photoData)
            Database.database().reference().child("photos").child("current").child(FirebaseManager.shared.uid).child(currentKey).setValue(photoData)
        })
    }
}
