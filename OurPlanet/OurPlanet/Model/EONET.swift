/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import Foundation
import RxSwift
import RxCocoa

class EONET {
    static let API = "https://eonet.sci.gsfc.nasa.gov/api/v2.1"
    static let categoriesEndpoint = "/categories"
    static let eventsEndpoint = "/events"
    
    static var ISODateReader: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return formatter
    }()
    
    static func filteredEvents(events: [EOEvent], forCategory category: EOCategory) -> [EOEvent] {
        return events.filter { event in
            return event.categories.contains(category.id) &&
                !category.events.contains {
                    $0.id == event.id
            }
            }
            .sorted(by: EOEvent.compareDates)
    }
    
    
    static func request(endpoint: String, query: [String: Any] = [:]) -> Observable<[String: Any]> {
        do {
            guard let url = URL(string: API)?.appendingPathComponent(endpoint), var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw EOError.invalidURL(endpoint)
            }
            
            // 두번째파라메터인 [String: Any] 형을 URLQueryItem형으로 변환 (변환실패가능성이 있으므로 flatMap)
            // flatMap변환실패시 throw를 반환하므로
            
            components.queryItems = try? query.flatMap { (key, value) in
                
                guard let v = value as? CustomStringConvertible else {
                    throw EOError.invalidParameter(key, value)
                }
                return URLQueryItem(name: key, value: v.description)
            }
            
            //마지막으로 url? -> url 로 변환
            guard let finalUrl = components.url else {
                throw EOError.invalidURL(endpoint)
            }
            
            // 안전하게 추출한 url을 가지고 request 하자!
            let request = URLRequest(url: finalUrl)
            
            // respons의 data 를 json으로시리얼라이즈 후 딕셔너리형의 [String: Any] 변환해서 반환함
            // 변환실패시에는 invalidJson 에러를 사용해서 finalUrl의 절대문자열을 스로우함!
            return URLSession.shared.rx.response(request: request)
                .map { _ , data -> [String: Any] in
                    
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []), let result = jsonObject as? [String: Any] else {
                        throw EOError.invalidJSON(finalUrl.absoluteString)
                    }
                    return result
            }
        } catch {
            return Observable.empty()
        }
    }
    
    // 이렇게 해당 endpoint 리퀘스트용 프로퍼티를 만들게 되면
    // 바로 EONET.categories 로 해서 request, response 할 수 있게 된다.
    static var categories: Observable<[EOCategory]> = {
       
        return EONET.request(endpoint: categoriesEndpoint)
            .map { data in
                
                let categories = data["categories"] as? [[String: Any]] ?? []
                return categories
                    .flatMap(EOCategory.init)
                    .sorted { $0.name < $1.name }
                
        }
        .shareReplay(1)
        
    }()
    
    fileprivate static func events(forLast days: Int, closed: Bool, endpoint: String) -> Observable<[EOEvent]> {
        
        return request(endpoint: endpoint,
                       query:["days": NSNumber(value: days),"status": (closed ? "closed" : "open")] )
            .map { json in
                guard let raw = json["events"] as? [[String: Any]] else {
                    throw EOError.invalidJSON(endpoint)
                }
                return raw.flatMap(EOEvent.init)
        }
    }
    
    static func events(forLast days: Int = 360, category: EOCategory) -> Observable<[EOEvent]> {
        let openEvents = events(forLast: days, closed: false, endpoint: category.endpoint)
        let closedEvents = events(forLast: days, closed: true, endpoint: category.endpoint)
        
        //return openEvents.concat(closedEvents) // ---- openEvents ----- closedEvents -----|->  (순차적)
        
        // In parallel
        return Observable.of(openEvents, closedEvents)
            .merge()
            .reduce([]) { running, new in
               return running + new
        }
    }

}









































