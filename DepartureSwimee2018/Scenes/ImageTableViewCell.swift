//
//  ImageTableViewCell.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}

extension ImageTableViewCell: NibLoadable, Reusable {}
