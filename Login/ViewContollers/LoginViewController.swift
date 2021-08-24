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


public extension Reactive where Base: Store<LoginViewState, LoginViewAction> {
    
    var username: Binder<String?> {
        Binder(self.base) { store, value in
            guard let value = value else {
                return
            }
            
            store.send(.login(.username(value)))
        }
    }
    
    var password: Binder<String?> {
        Binder(self.base) { store, value in
            guard let value = value else {
                return
            }
            
            store.send(.login(.password(value)))
        }
    }
    
    var login: Binder<Void> {
        Binder(self.base) { store, value in
            store.send(.login(.login))
        }
    }
    
    var rememberMe: Binder<Bool> {
        Binder(self.base) { store, value in
            store.send(LoginViewAction.login(LoginAction.rememberMe(value)))
        }
    }
    
}

let envLoginSuccess: Login = {  _,_ in .sync { .success("") } }
let envLoginFailureGeneric: Login = {  _,_ in .sync { .failure(.generic) } }
let envLoginFailureCredentials: Login = {  _,_ in .sync { .failure(.invalidCredentials("invalid credentials")) } }

let initialState: LoginViewState = LoginViewState(
    username: "",
    password: "",
    isLoading: false,
    isEnabled: false,
    alert: nil,
    rememberMeStatus: false
)

let env: LoginViewEnvironment = (
    login: envLoginSuccess,
    saveCredentials: { _,_ in  .sync { true } },
    retrieveCredentials: { username in .sync { ("fake@email.com", "Aa123123") } },
    ereaseCredentials: { username in .sync { true } }
)

extension Reactive where Base: UIViewController {
    var present: Binder<UIViewController?> {
        Binder(self.base) { from, destination in
            guard let destination = destination else {
                return
            }
            
            from.navigationController?.present(destination, animated: true)
        }
    }
    
    var presentAlertError: Binder<UIAlertController?> {
        Binder(self.base) { from, destination in
            guard let destination = destination else {
                return
            }
            
            from.navigationController?.present(destination, animated: true)
        }
    }
}

public class LoginViewController: UIViewController, StoreViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var rememberMeSwitch: UISwitch!
    
    private let disposeBag = DisposeBag()
    
    public var store: Store<LoginViewState, LoginViewAction>?
    
    public typealias State = LoginViewState
    public typealias Action = LoginViewAction
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let store = self.store else {
            fatalError()
        }
		
        // MARK: - Remember Me
        
        store.send(LoginViewAction.login(LoginAction.checkRememberMeStatus))
        
        store
            .state
			.distinctUntilChanged()
            .map { $0.rememberMeStatus }
            .distinctUntilChanged()
            .bind(to: rememberMeSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        rememberMeSwitch.rx
            .isOn
            .bind(to: store.rx.rememberMe)
            .disposed(by: disposeBag)
        
        store
            .state
			.distinctUntilChanged()
            .map { $0.isEnabled }
            .distinctUntilChanged()
            .bind(to: rememberMeSwitch.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // MARK: - Username
        
        store
            .state
			.distinctUntilChanged()
            .map { $0.username }
            .bind(to: usernameField.rx.text)
            .disposed(by: disposeBag)
        
        usernameField.rx
            .text
			.distinctUntilChanged()
            .bind(to: store.rx.username)
            .disposed(by: disposeBag)
		        
        // MARK: - Password

        store
            .state
			.distinctUntilChanged()
            .map { $0.password }
            .bind(to: passwordField.rx.text)
            .disposed(by: disposeBag)
        
        passwordField.rx
            .text
            .bind(to: store.rx.password)
            .disposed(by: disposeBag)
        
        // MARK: - Login
        
        loginButton.rx
            .tap
            .bind { store.send(.login(.login)) }
            .disposed(by: disposeBag)
        
        store
            .state
			.distinctUntilChanged()
            .map { $0.isEnabled }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // MARK: - Login alert
        
//        store
//            .value
//            .map { $0.alert }
//            .distinctUntilChanged()
//            .map { $0?.content }
//            .map { $0 ?? "" }
//            .messageAlertController()
//            .bind(to: self.rx.presentAlertError)
//            .disposed(by: disposeBag)
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

extension Observable where Element == Error? {
    func errorAlertController() -> Observable<UIAlertController?> {
        map { error in
            guard let error = error else {
                return nil
            }
            
            let alert = UIAlertController(
                title: error.localizedDescription,
                message: "",
                preferredStyle: UIAlertController.Style.alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: NSLocalizedString("ok", comment: ""),
                    style: UIAlertAction.Style.default,
                    handler: { _ in  }
                )
            )
            
            return alert
        }
    }
}

extension Observable where Element == String {
    func messageAlertController() -> Observable<UIAlertController?> {
        map { message in
            let alert = UIAlertController(
                title: message,
                message: "",
                preferredStyle: UIAlertController.Style.alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: NSLocalizedString("ok", comment: ""),
                    style: UIAlertAction.Style.default,
                    handler: { _ in  }
                )
            )
            
            return alert
        }
    }
}
