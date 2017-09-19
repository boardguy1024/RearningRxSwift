//
//  EOCategory.swift
//  sample
//
//  Created by park kyung suk on 2017/09/17.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class EOCategory: Equatable {
    
    let id: Int
    let name: String
    let description: String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["title"] as? String,
              let description = json["description"] as? String else { return nil }
        self.id = id
        self.name = name
        self.description = description
    }
    
    static func == (_ left: EOCategory, _ right: EOCategory) -> Bool {
        return left.id == right.id
    }
}
