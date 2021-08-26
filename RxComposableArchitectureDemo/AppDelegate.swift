//
//  AppDelegate.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import SceneBuilder
import RxComposableArchitecture

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		// MARK: - Counter
		
		let counter = Scene<CounterViewController>()
			.render()
			.apply {
				$0.store = applicationStore.scope(
					value: { $0.counterView },
					action: { .counter($0) }
				)
			}
		
		let counterNav = UINavigationController.init(rootViewController: counter)
		
		// MARK: - Favorites
		
		let favorites = Scene<FavoritesViewController>()
			.render()
			.apply {
				$0.store = applicationStore.scope(
					value: { $0.favoritesView },
					action: { .favorites($0) }
				)
			}
				
		// Tab bar
		let tabBarController = UITabBarController()
		
		let item1 = UITabBarItem(title: "Counter", image: UIImage(named: ""), tag: 0)
		let item2 = UITabBarItem(title: "Favorites", image:  UIImage(named: ""), tag: 1)
		
		counterNav.tabBarItem = item1
		favorites.tabBarItem = item2
		
		tabBarController.setViewControllers([
			counterNav,
			favorites
		], animated: false)
		
		// Window root
		self.window?.rootViewController = tabBarController
		
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}
