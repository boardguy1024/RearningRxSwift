//
//  PHPhotoLibrary+rx.swift.swift
//  Combinestagram
//
//  Created by park kyung suk on 2017/08/30.
//  Copyright © 2017年 Underplot ltd. All rights reserved.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
    
    static var authorized: Observable<Bool> {
        return Observable.create { observer in
            
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    //onNext 이벤트가 2번 방출된다.
                    observer.onNext(false)
                    requestAuthorization { newStatus in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}
