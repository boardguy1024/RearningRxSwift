//
//  Event.swift
//  TestAppWithRxSwift
//
//  Created by park kyung suk on 2017/09/03.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class Event {
    
    typealias anyDict = [String: Any]
    
    let repo: String
    let name: String
    let imageUrl: URL
    
    init?(dictionary: anyDict) {
        
        guard let repoDict = dictionary["repo"] as? anyDict,
            let actorDict = dictionary["actor"] as? anyDict,
            
            let repoName = repoDict["name"] as? String,
            let actorName = actorDict["display_login"] as? String,
            let actorImageurlString = actorDict["avatar_url"] as? String,
            let actorImageUrl = URL(string: actorImageurlString) else { return nil }
        
        repo = repoName
        name = actorName
        imageUrl = actorImageUrl
    }
    
    //MARK: - Event -> JSON
    var dictionary: anyDict {
        return [
            "repo" : ["name": repo],
            "actor" : ["display_login": name , "avatar_url": imageUrl]
        ]
    }
}











