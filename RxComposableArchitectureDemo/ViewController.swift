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

enum Authentication {
    case authenticated(AccessToken)
    case unauthenticated
}

struct AccessToken {
    var token: String
}

extension AccessToken: Equatable {}

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
    
    public var store: Store<CounterViewState, CounterViewAction>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let store = store else {
            return
        }
        
        decr.rx.tap.bind { [weak self] in self?.store.send(.counter(.decrTapped)) }.disposed(by: disposeBag)
        incr.rx.tap.bind { [weak self] in self?.store.send(.counter(.incrTapped)) }.disposed(by: disposeBag)
        
        store
            .value
            .map { String($0.count) }
            .bind(to: counter.rx.text)
            .disposed(by: disposeBag)
        
        store
            .value
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(SwiftSpinner.shared.rx_visible)
            .disposed(by: disposeBag)
    }
    
}
