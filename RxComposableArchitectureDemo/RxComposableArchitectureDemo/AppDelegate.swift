//
//  AppDelegate.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 17/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import UIKit
import RxComposableArchitecture

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootScene = Scene<RootViewController>().render()
        
        self.window?.rootViewController = UINavigationController(rootViewController: rootScene)
        
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white
        
        return true
    }
}

