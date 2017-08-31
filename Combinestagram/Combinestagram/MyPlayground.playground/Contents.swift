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

struct Student {
    
    var score: Variable<Int>
}

example(of: "flatMapFirst") {
    
    
    let park = Student(score: Variable(80))
    let kim = Student(score: Variable(90))
    
    let student = PublishSubject<Student>()
    
    student.asObservable()
        .flatMapFirst {
            $0.score.asObservable()
    }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
    
    
    student.onNext(park)
    
    park.score.value = 85
    
    student.onNext(kim)
    
    park.score.value = 95
    
    kim.score.value = 100
    
    
    
    
}
























