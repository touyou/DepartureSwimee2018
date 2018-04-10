//
//  LoadingButton.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/04/10.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {

    var indicatorView: UIActivityIndicatorView!
    var titleString: String?
    
    func startLoading(_ center: CGPoint) {
        
        indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.activityIndicatorViewStyle = .whiteLarge
        indicatorView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addSubview(indicatorView)
        titleString = self.title(for: .normal)
        setTitle(nil, for: .normal)
        indicatorView.startAnimating()
        self.isEnabled = false
    }
    
    func stopLoading() {
        
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
        setTitle(titleString, for: .normal)
        self.isEnabled = true
    }
}
