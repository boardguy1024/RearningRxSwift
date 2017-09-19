//
//  EONET.swift
//  sample
//
//  Created by park kyung suk on 2017/09/17.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import RxSwift

class EONET {
    
    static let API = "https://eonet.sci.gsfc.nasa.gov/api/v2.1"
    static let categoriesEndpoint = "/categories"
    static let eventsEndpoint = "/events"
    
    static func request(endpoint: String, query: [String: Any] = [:]) -> Observable<[String: Any]> {
        
        do {
            guard let url = URL(string: API)?.appendingPathComponent(endpoint),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    throw EOError.invalidUrl(endpoint)
            }
            components.queryItems = try query.flatMap { (key, value) in
                guard let v = value as? CustomStringConvertible else {
                    throw EOError.invalidParameter(key, value)
                }
                return URLQueryItem(name: key, value: v.description)
            }
            guard let finalUrl = components.url  else {
                throw EOError.invalidUrl(endpoint)
            }
            let request = URLRequest(url: finalUrl)
            
            return URLSession.shared.rx.response(request: request)
                .map { _ , data -> [String: Any] in
                    
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []), let result = jsonObject as? [String: Any] else {
                        throw EOError.invalidJson(finalUrl.absoluteString)
                    }
                    return result
            }
        } catch {
            return Observable.empty()
        }
        
    }
    
    static var categories: Observable<[EOCategory]> = {
       
        return EONET.request(endpoint: categoriesEndpoint)
            .map { data in
                let categories = data["categories"] as? [[String: Any]] ?? []
                return categories
                    .flatMap(EOCategory.init)
                    .sorted{ $0.name < $1.name }
                
        }
        .shareReplay(1)
    }()
}
