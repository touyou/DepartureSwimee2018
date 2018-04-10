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
    
    func startLoading() {
        
        indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.activityIndicatorViewStyle = .whiteLarge
        indicatorView.center = self.center
        self.addSubview(indicatorView)
        titleString = self.title(for: .normal)
        setTitle(nil, for: .normal)
        indicatorView.startAnimating()
    }
    
    func stopLoading() {
        
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
        setTitle(titleString, for: .normal)
    }
}
