//
//  MainCollectionViewCell.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView! {
        
        didSet {
            
            iconImageView.cornerRadius = (UIScreen.main.bounds.width - 30.0) / 6.0
            iconImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MainCollectionViewCell: NibLoadable, Reusable {}
