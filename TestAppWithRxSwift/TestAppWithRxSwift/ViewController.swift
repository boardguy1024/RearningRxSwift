//
//  ViewController.swift
//  TestAppWithRxSwift
//
//  Created by park kyung suk on 2017/09/03.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let repoName = "ReactiveX/RxSwift"
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSonData()
    }
    
    func getJSonData() {
        
        let response = Observable.from([repoName])
            .map { urlString -> URL in
                return URL(string: "http://api.github.com/repos/\(urlString)/events")!
        }
            .map { url -> URLRequest in
                return URLRequest(url: url)
        }
            .flatMap { urlRequest -> Observable<(HTTPURLResponse, Data)> in
                return URLSession.shared.rx.response(request: urlRequest)
        }
        
        response
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
        }
            .map { _ , data -> [[String: Any]] in
                
                print("data: \(data)")
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []), let result = jsonData as? [[String: Any]] else { return [] }
                return result
        }
            .filter { resultObject in
                return resultObject.count > 0
        }
            .map { objects in
                return objects.flatMap(Event.init)
            }
            .subscribe(onNext: {
               print("name: \($0[1].name)")
               print("imageUrl: \($0[1].imageUrl)")
            })
            .disposed(by: bag)
    }
}

