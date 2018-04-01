//
//  PhotoViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import Kingfisher

class PhotoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(PhotoCollectionViewCell.self)
        }
    }
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Photos"
        navigationController?.setupBarColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if FirebaseManager.shared.isLoggedIn {
            
            /// 卒業生はみんなから送られてきた写真、その他の人は自分が送った写真が見れるようにする
            /// つまり写真を送るときは二箇所に保存しておく
            Database.database().reference().child("photos").child(FirebaseManager.shared.isGrad ? "current" : "grad").child(FirebaseManager.shared.uid ?? "unknown").observe(.value, with: { [unowned self] snapshot in
                
                let children = snapshot.children.map { ($0 as! DataSnapshot).value }
                do {
                    
                    self.photos = try FirebaseDecoder().decode([Photo].self, from: children)
                    self.collectionView.reloadData()
                } catch let error {
                    
                    print(error)
                }
            })
        }
    }
    
    deinit {
        
        Database.database().reference().child("photos").child(FirebaseManager.shared.isGrad ? "current" : "grad").child(FirebaseManager.shared.uid ?? "unknown").removeAllObservers()
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.imageView.kf.setImage(with: photos[indexPath.row].url, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth - 1.0) / 2.0, height: (screenWidth - 1.0) / 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
}
