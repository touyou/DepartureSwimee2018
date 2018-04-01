//
//  MessageTableViewCell.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}

extension MessageTableViewCell: NibLoadable, Reusable {}
