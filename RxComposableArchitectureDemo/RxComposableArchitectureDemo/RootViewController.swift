//
//  RootViewController.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 16/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import UIKit
import RxSwift
import RxComposableArchitecture

class RootViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Observable<Int>
            .interval(1.0, scheduler: MainScheduler.instance)
            .startWith(0)
            .debug("[\(self.debugDescription)]", trimOutput: false)
            .flatMap { time -> Observable<Bool> in .just(time % 2 == 0) }
            .bind(to: mainLabel.rx.isVisible)
            .disposed(by: disposeBag)
    }
}
