//: Playground - noun: a place where people can play

import UIKit
import RxSwift


let value = PublishSubject<[Int]>()

let result = Observable.from(value)

