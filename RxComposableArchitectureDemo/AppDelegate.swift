//
//  AppDelegate.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import SceneBuilder
import RxComposableArchitecture
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	private let disposeBag = DisposeBag()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		// MARK: - Counter
				
		let counterStore = applicationStore.scope(
			state: { $0.counterView },
			action: { .counter($0) }
		)
		
		let counter = CounterViewController(
			store: counterStore
		)
		
		// MARK: - Favorites
		
		let favorites = FavoritesViewController(
			store: applicationStore.scope(
				state: { $0.favoritesView },
				action: { .favorites($0) }
			)
		)
		
		// MARK: - Handle global GENERIC ERROR
		
//		applicationStore.state
//			.map { $0.genericError }
//			.ignoreNil()
//			.subscribe { (state: GenericErrorState) in
//				if let topVC = UIApplication.getTopViewController() {
//					let ac = UIAlertController(
//						title: state.title,
//						message: state.message,
//						preferredStyle: UIAlertController.Style.alert
//					)
//
//					ac.addAction(
//						UIAlertAction(
//							title: "dismiss",
//							style: UIAlertAction.Style.cancel,
//							handler: { (a: UIAlertAction) in
//								applicationStore.send(AppAction.genericError(GenericErrorAction.dismiss))
//							}
//						)
//					)
//
//					topVC.present(ac, animated: true, completion: nil)
//				}
//
//			}.disposed(by: disposeBag)

				
		// Tab bar
		let tabBarController = UITabBarController()
		
		let item1 = UITabBarItem(title: "Counter", image: UIImage(named: ""), tag: 0)
		let item2 = UITabBarItem(title: "Favorites", image:  UIImage(named: ""), tag: 1)
		
		counter.tabBarItem = item1
		favorites.tabBarItem = item2
		
		tabBarController.setViewControllers([
			counter,
			favorites
		], animated: false)
		
		// Window root
		self.window?.rootViewController = tabBarController
		
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}

extension UIApplication {
	
	class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		if let nav = base as? UINavigationController {
			return getTopViewController(base: nav.visibleViewController)
			
		} else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
			return getTopViewController(base: selected)
			
		} else if let presented = base?.presentedViewController {
			return getTopViewController(base: presented)
		}
		
		return base
	}
	
}
