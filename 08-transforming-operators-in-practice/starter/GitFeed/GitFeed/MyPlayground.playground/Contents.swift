//: Playground - noun: a place where people can play

import UIKit
import RxSwift



let o = Observable.from(["food","flult"])

o.map { urlString -> URL in
    
    return URL(string: "http://www.aaa.com/\(urlString)")!
}
    .subscribe {
        print($0)
}