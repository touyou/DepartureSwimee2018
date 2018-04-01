//
//  AddTableViewCell.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class AddTableViewCell: UITableViewCell {
    
    var action: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    @IBAction func tapAddButton() {
        
        action?()
    }
}

extension AddTableViewCell: NibLoadable, Reusable {}
