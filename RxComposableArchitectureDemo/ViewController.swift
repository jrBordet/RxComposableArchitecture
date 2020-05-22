//
//  ViewController.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import UIKit
import RxComposableArchitecture
import RxSwift
import SwiftSpinner

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Observable<NSInteger>
            .interval(1, scheduler: MainScheduler.instance)
            .map { $0 <= 3 ? true : false }
            .asDriver(onErrorJustReturn: false)
            .drive(SwiftSpinner.shared.rx_visible)
            .disposed(by: disposeBag)
    }
}
