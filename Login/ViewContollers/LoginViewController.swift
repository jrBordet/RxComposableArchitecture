//
//  LoginViewController.swift
//  Login
//
//  Created by Jean Raphael Bordet on 27/08/2020.
//

import UIKit
import RxSwift
import RxCocoa
import RxComposableArchitecture

let envLoginSuccess: (String, String) -> Effect<Result<String, LoginError>> =  {  _,_ in .sync { .success("") } }
let envLoginFailureGeneric: (String, String) -> Effect<Result<String, LoginError>> =  {  _,_ in .sync { .failure(.generic) } }
let envLoginFailureCredentials: (String, String) -> Effect<Result<String, LoginError>> =  {  _,_ in .sync { .failure(.invalidCredentials("invalid credentials")) } }

public class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    public var store: Store<LoginViewState, LoginViewAction>?
    
    let initialState: LoginViewState = LoginViewState(
        username: "",
        password: "",
        isLoading: false,
        isEnabled: false,
        alert: nil
    )
    
    let env: LoginViewEnvironment = (
        login: envLoginSuccess,
        saveCredentials: { _,_ in  .sync { true } }
    )
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        store = Store(initialValue: initialState, reducer: loginViewReducer, environment: env)
                
        guard let store = self.store else {
            fatalError()
        }
        
        store.value.map { $0.isEnabled }.subscribe().disposed(by: disposeBag)
    }
    
    // MARK: - Init
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
