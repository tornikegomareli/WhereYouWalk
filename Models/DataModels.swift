//
//  PhotoCollection.swift
//  KomootChallenge
//
//  Created by Tornike Gomareli on 5/8/19.
//  Copyright © 2019 Tornike Gomareli. All rights reserved.
//

import Foundation


struct PhotoCollection : Codable {
    let photos: Photos
    let stat: String
}

struct Photos : Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
