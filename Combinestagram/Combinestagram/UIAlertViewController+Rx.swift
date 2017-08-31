//
//  UIAlertViewController+Rx.swift
//  Combinestagram
//
//  Created by park kyung suk on 2017/08/31.
//  Copyright © 2017年 Underplot ltd. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
    
    func alert(title: String, text: String?) -> Observable<Void> {
        
        return Observable.create { [weak self] observer in
            
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
                //ボタンをタップした場合には .onCompletedを流す
                observer.onCompleted()
            }))
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        }
    }
}
