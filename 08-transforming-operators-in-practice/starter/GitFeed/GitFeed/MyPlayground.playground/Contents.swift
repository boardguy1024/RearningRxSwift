//: Playground - noun: a place where people can play

import UIKit
import RxSwift


let source = Observable.of(1,2,3,4,5)

let observable = source.scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })