//
//  ViewController.swift
//  sample
//
//  Created by park kyung suk on 2017/09/17.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categories = Variable<[EOCategory]>([])
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories
            .asObservable()
            .subscribe(onNext: { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        startDownload()
    }
    
    func startDownload() {
        let eoCaterogies = EONET.categories
        eoCaterogies
            .bind(to: categories)
            .disposed(by: disposeBag)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let category = categories.value[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
}

