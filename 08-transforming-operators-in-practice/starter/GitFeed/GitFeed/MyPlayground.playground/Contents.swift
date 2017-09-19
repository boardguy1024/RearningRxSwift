//: Playground - noun: a place where people can play

import UIKit
import RxSwift


let left = PublishSubject<String>()
let right = PublishSubject<String>()

let obaservable = left.amb(right)
let disposable = obaservable.subscribe(onNext: {
    print($0)
})

left.onNext("a")
right.onNext("aa")

disposable.dispose()