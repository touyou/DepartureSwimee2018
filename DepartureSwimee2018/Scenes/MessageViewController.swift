//
//  MessageViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.register(MessageTableViewCell.self)
            tableView.register(ImageTableViewCell.self)
            tableView.register(AddTableViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
}
