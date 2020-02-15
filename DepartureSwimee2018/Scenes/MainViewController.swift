//
//  MainViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(MainCollectionViewCell.self)
        }
    }
    
    var users: [User] = []
    var messagedUserUID: [String] = []
    var filteredUser: [User] {

        return users.filter { messagedUserUID.firstIndex(of: $0.uid) != nil }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Home"
        navigationController?.setupBarColor()
        tabBarController?.tabBar.tintColor = UIColor.Swimee.tintRed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if FirebaseManager.shared.isLoggedIn {
            
            Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "current" : "grad").observe(.value, with: { [unowned self] snapshot in
                
                let children = snapshot.children.map { ($0 as! DataSnapshot).value }
                do {
                    
                    self.users = try FirebaseDecoder().decode([User].self, from: children)
                    self.collectionView.reloadData()
                } catch let error {
                    
                    print(error)
                }
            })
            // 自分のデータもついでに登録しておく
            let me = User(name: FirebaseManager.shared.loggedInUserName, iconUrl: FirebaseManager.shared.photoURL, uid: FirebaseManager.shared.uid)
            let data = try! FirebaseEncoder().encode(me)
            Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "grad" : "current").child(FirebaseManager.shared.uid).setValue(data)
            if FirebaseManager.shared.isGrad {
                Database.database().reference().child("messages").child(FirebaseManager.shared.uid).observe(.value, with: { [unowned self] snapshot in

                    self.messagedUserUID = snapshot.children.map { ($0 as! DataSnapshot).key }
                    self.collectionView.reloadData()
                })
            }
        } else {
            
            let viewController = UINavigationController(rootViewController: AccountBaseViewController.instantiate())
            viewController.isNavigationBarHidden = true
            present(viewController, animated: true, completion: nil)
        }
    }
    
    deinit {
        
        Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "current" : "grad").removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMessage" {
            
            let viewController = segue.destination as! MessageViewController
            if FirebaseManager.shared.isGrad {

                viewController.opponentUid = filteredUser[sender as! Int].uid
            } else {

                viewController.opponentUid = users[sender as! Int].uid
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if FirebaseManager.shared.isGrad {

            return messagedUserUID.count
        } else {

            return users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        let user: User
        if FirebaseManager.shared.isGrad {

            user = filteredUser[indexPath.row]
        } else {

            user = users[indexPath.row]
        }

        cell.iconImageView.kf.setImage(with: user.iconUrl, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
        cell.nameLabel.text = user.name
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toMessage", sender: indexPath.row)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth / 3.0, height: screenWidth / 3.0 * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}

