//
//  Todo.swift
//  insta-clone-client
//
//  Created by David Choi on 10/9/20.
//

import Foundation

class Todo: Codable, Identifiable {
    var id: UUID?
    var title: String
    var desc: String
    
    init(id: UUID = UUID(), title: String, desc: String) {
        self.id = id
        self.title = title
        self.desc = desc
    }
}
