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
        
        Result<Int, Error>.successCasePath // CasePath<Result<Int, Error>, Int>
        Result<Int, Error>.failureCasePath // CasePath<Result<Int, Error>, Error>
        
        if let result = Result<Int, Error>.successCasePath.extract(.success(5)) {
            dump(result)
        }
        
//        if let error = Result<Int, Error>.failureCasePath.extract(.failure(NSError())) {
//            dump(error)
//        }
        
        let authenticatedCasePath = CasePath<Authentication, AccessToken>(
            extract: {
                if case let .authenticated(accessToken) = $0 { return accessToken }
                return nil
        },
            embed: Authentication.authenticated
        )
        
        let auth = Result<Authentication, Error>.successCasePath.appending(path: authenticatedCasePath)
        
        if let token = auth.extract(.success(.authenticated(AccessToken(token: "LKJKJ")))) {
            dump(token)
        }
        
       let auth2 = Result<Authentication, Error>.successCasePath .. authenticatedCasePath

        let getAuth = ^authenticatedCasePath
        if let accessToken = getAuth(Authentication.authenticated(AccessToken(token: "KJKJ"))) {
            dump(accessToken)
        }
        
        let authentications: [Authentication] = [
          .authenticated(AccessToken(token: "deadbeef")),
          .unauthenticated,
          .authenticated(AccessToken(token: "cafed00d"))
        ]

        let r1 = authentications
          .compactMap(^authenticatedCasePath)
        
        dump(r1)

        let r2 = authentications
          .compactMap { authentication -> AccessToken? in
            if case let .authenticated(accessToken) = authentication {
              return accessToken
            }
            return nil
        }
        
        dump(r2)
        
    }
    
}
