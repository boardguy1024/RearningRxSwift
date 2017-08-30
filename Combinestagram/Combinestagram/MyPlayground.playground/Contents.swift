//: Playground - noun: a place where people can play

import UIKit
import RxSwift

var str = "Hello, playground"

//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

let bag = DisposeBag()

public func example(of description: String, action: () -> ()) {
    
    print("\n--- Example of: ", description, "---")
    action()
}
enum MyError: Error {
    case anError
}

// print 오버라이드 한거임
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

example(of: "") {
    
    
    
    
}

let numbers = Observable<Int>.create { observer in
    
    let start = getStartNumber()
    observer.onNext(start)
    observer.onNext(start + 1)
    observer.onNext(start + 2)
    observer.onCompleted()
    
    return Disposables.create()
}


var start = 0

func getStartNumber() -> Int {
    start += 1
    return start
}

numbers.subscribe(onNext: { element in
    print("Element [\(element)]")
}, onCompleted: {
    print("--------------")
})

numbers.subscribe(onNext: { element in
    print("Element [\(element)]")
}, onCompleted: {
    print("--------------")
})
























