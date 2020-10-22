//
//  User.swift
//  insta-clone-client
//
//  Created by David Choi on 10/8/20.
//

import Foundation

struct Me: Decodable {
    var id: UUID
    var userName: String
}

struct UserLogin: Encodable {
    var userName: String
    var password: String
    
}
