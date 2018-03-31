//
//  PhotoCollectionViewCell.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}

extension PhotoCollectionViewCell: NibLoadable, Reusable {}
