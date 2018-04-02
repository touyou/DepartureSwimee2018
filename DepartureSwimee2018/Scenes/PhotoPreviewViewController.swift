//
//  PhotoPreviewViewController.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/04/02.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoUrl: URL!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Preview"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        photoImageView.kf.setImage(with: photoUrl, placeholder: #imageLiteral(resourceName: "placeholder-icon"))
    }
}
