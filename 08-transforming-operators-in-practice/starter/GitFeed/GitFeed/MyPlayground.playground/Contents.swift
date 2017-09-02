//: Playground - noun: a place where people can play

import UIKit
import RxSwift



let array1 = [1,2,3]
let array2 = [4,5,6]

var array3 = array1 + array2










let o = Observable.of(1,2,3)
    .map { $0 * 2 }


o.subscribe(onNext: {
    print($0)
})

o.subscribe(onNext: {
    print($0)
})



