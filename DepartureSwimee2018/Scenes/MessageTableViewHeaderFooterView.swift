//
//  MessageTableViewHeaderFooterView.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class MessageTableViewHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
}

extension MessageTableViewHeaderFooterView: NibLoadable, Reusable {}
