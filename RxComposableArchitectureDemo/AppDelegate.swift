//
//  AppDelegate.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import SceneBuilder
import RxComposableArchitecture
import Login

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // MARK: - Counter
//        let counterStore = applicationStore.view(
//            value: { $0.counter },
//            action: { AppAction.counter($0) }
//        )
//
//        let counterScene = Scene<ViewController>().render()
//
//        counterScene.store = counterStore
        
        
//        let counterStore = Scene<ViewController>()
//            .render()
//            .apply {
//                $0.store = applicationStore.scope(
//                    value: { $0.counter },
//                    action: { AppAction.counter($0) }
//                )
//            }
        
        
        // MARK: - Login
        let loginScene = UIViewController
            .login
            .apply {
                $0.store = applicationStore.scope(
                    value: { $0.login },
                    action: { .login($0) }
                )
            }
        
        self.window?.rootViewController = UINavigationController(rootViewController: loginScene)
        
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white 
        
        return true
    }
}

extension UIViewController {
    static var login: LoginViewController = Scene<LoginViewController>().render()
}
