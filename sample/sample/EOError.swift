//
//  EOError.swift
//  sample
//
//  Created by park kyung suk on 2017/09/17.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

enum EOError: Error {
    case invalidUrl(String)
    case invalidParameter(String, Any)
    case invalidJson(String)
}
