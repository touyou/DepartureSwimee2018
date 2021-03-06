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
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .none
            tableView.backgroundColor = .white
        }
    }
    
    var messages: [Message] = []
    var opponentUid: String!
    var opponent: User?
    var refresh: UIActivityIndicatorView?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPhoto" {
            
            let viewController = segue.destination as! PhotoPreviewViewController
            viewController.photoUrl = messages[sender as! Int].photoUrl
        }
        if segue.identifier == "toEdit" {
            
            let viewController = segue.destination as! EditViewController
            viewController.opponentUid = opponentUid
            viewController.message = sender as? Message
        }
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
                        
                        let key = Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).childByAutoId().key
                        let message = Message(fromUser: FirebaseManager.shared.uid, message: nil, photoUrl: nil, key: key!, gradPhotoKey: nil, currentPhotoKey: nil)
                        
                        self.performSegue(withIdentifier: "toEdit", sender: message)
                    })
                    .addAction(title: "写真", style: .default, handler: { _ in
                        
                        let _ = UIAlertController(title: "写真を選択", message: "写真の選択方法を選んでください。", preferredStyle: .actionSheet)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < messages.count {
            
            if messages[indexPath.row].message != nil && !FirebaseManager.shared.isGrad {
                
                // メッセージ編集画面へ
                performSegue(withIdentifier: "toEdit", sender: messages[indexPath.row])
            } else if messages[indexPath.row].photoUrl != nil {
                
                // 画像のプレビューへ
                performSegue(withIdentifier: "toPhoto", sender: indexPath.row)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return !FirebaseManager.shared.isGrad
    }
}

extension MessageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        refresh = UIActivityIndicatorView()
        refresh?.style = .gray
        refresh?.center = self.view.center
        refresh?.startAnimating()
        view.addSubview(refresh!)
        FirebaseManager.shared.uploadPhoto(image, isProfile: false, completion: { [unowned self] url in
            
            // メッセージとしてのデータ
            let key = Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).childByAutoId().key
            let gradKey = Database.database().reference().child("photos").child("grad").child(self.opponentUid).childByAutoId().key
            let currentKey = Database.database().reference().child("photos").child("current").child(FirebaseManager.shared.uid).childByAutoId().key
            let message = Message(fromUser: FirebaseManager.shared.uid, message: nil, photoUrl: url, key: key!, gradPhotoKey: gradKey, currentPhotoKey: currentKey)
            let messageData = try! FirebaseEncoder().encode(message)
            
            Database.database().reference().child("messages").child(self.opponentUid).child(FirebaseManager.shared.uid).child(key!).setValue(messageData)
            
            // 写真一覧としてのデータ
            let photo = Photo(url: url)
            let photoData = try! FirebaseEncoder().encode(photo)
            
            Database.database().reference().child("photos").child("grad").child(self.opponentUid).child(gradKey!).setValue(photoData)
            Database.database().reference().child("photos").child("current").child(FirebaseManager.shared.uid).child(currentKey!).setValue(photoData)
            
            self.refresh?.stopAnimating()
            self.refresh?.removeFromSuperview()
        })
    }
}
