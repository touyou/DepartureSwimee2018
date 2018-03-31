//
//  UINavigationController+Extensions.swift
//  GitMe
//
//  Created by 藤井陽介 on 2018/02/09.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit

// MARK: - Project Layout

extension UINavigationController {

    func setupBarColor() {

        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationBar.barTintColor = UIColor.Swimee.barOrange
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.backgroundColor = UIColor.Swimee.barOrange
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}
