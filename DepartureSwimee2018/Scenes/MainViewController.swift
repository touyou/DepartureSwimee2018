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
            let me = User(name: FirebaseManager.shared.loggedInUserName, iconUrl: FirebaseManager.shared.photoURL, uid: FirebaseManager.shared.uid ?? "unknown")
            let data = try! FirebaseEncoder().encode(me)
            Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "grad" : "current").child(FirebaseManager.shared.uid ?? "unknown").setValue(data)
        } else {
            
            let viewController = UINavigationController(rootViewController: AccountBaseViewController.instantiate())
            viewController.isNavigationBarHidden = true
            present(viewController, animated: true, completion: nil)
        }
    }
    
    deinit {
        
        Database.database().reference().child("users").child(FirebaseManager.shared.isGrad ? "current" : "grad").removeAllObservers()
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.iconImageView.kf.setImage(with: users[indexPath.row].iconUrl, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
        cell.nameLabel.text = users[indexPath.row].name
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: メッセージ登録画面などに行く
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

