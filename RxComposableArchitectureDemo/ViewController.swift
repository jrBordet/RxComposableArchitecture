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
    @IBOutlet var decr: UIButton!
    @IBOutlet var incr: UIButton!
    @IBOutlet var counter: UILabel!
    
    let initalState = CounterViewState(count: 0, isLoading: false, alertNthPrime: nil)
    
    let env: CounterViewEnvironment = (
        counter: { _ in .sync { 5 } },
        other: { .sync { true } }
    )
    
    private var store: Store<CounterViewState, CounterViewAction>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store = Store<CounterViewState, CounterViewAction>(
            initialValue: initalState,
            reducer: counterViewReducer,
            environment: env
        )
        
        decr.rx.tap.bind { [weak self] in self?.store.send(.counter(.decrTapped)) }.disposed(by: disposeBag)
        incr.rx.tap.bind { [weak self] in self?.store.send(.counter(.incrTapped)) }.disposed(by: disposeBag)
        
        store
            .value
            .map { String($0.count) }
            .bind(to: counter.rx.text)
            .disposed(by: disposeBag)

        Observable<NSInteger>
            .interval(1, scheduler: MainScheduler.instance)
            .map { $0 <= 3 ? true : false }
            .asDriver(onErrorJustReturn: false)
            .drive(SwiftSpinner.shared.rx_visible)
            .disposed(by: disposeBag)
    }
}
