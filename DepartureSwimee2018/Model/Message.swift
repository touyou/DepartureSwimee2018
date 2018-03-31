//
//  Message.swift
//  DepartureSwimee2018
//
//  Created by 藤井陽介 on 2018/03/31.
//  Copyright © 2018 Swimee. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    let fromUser: String
    let messages: [String]
    let photos: [Photo]
}

struct Photo: Codable {
    
    let url: URL?
}

struct User: Codable {
    
    let name: String
    let iconUrl: URL
    let photos: [Photo]
}
