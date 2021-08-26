//
//  RxExtensions.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 25/08/21.
//

import Foundation
import RxSwift

extension Observable where Element: OptionalType {
	func ignoreNil() -> Observable<Element.Wrapped> {
		flatMap { value -> Observable<Element.Wrapped> in
			guard let value = value.value else {
				return Observable<Element.Wrapped>.empty()
			}
			
			return Observable<Element.Wrapped>.just(value)
		}
	}
}

public protocol OptionalType {
	associatedtype Wrapped
	var value: Wrapped? { get }
}

extension Optional: OptionalType {
	/// Cast `Optional<Wrapped>` to `Wrapped?`
	public var value: Wrapped? {
		return self
	}
}

extension Observable where Element == String {
	func messageAlertController(_ handler: @escaping() -> Void) -> Observable<UIAlertController?> {
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
					handler: { _ in handler()  }
				)
			)
			
			return alert
		}
	}
}

extension Reactive where Base: UIViewController {
	var present: Binder<UIViewController?> {
		Binder(self.base) { from, destination in
			guard let destination = destination else {
				return
			}
			
			from.navigationController?.present(destination, animated: true)
		}
	}
	
	var presentAlert: Binder<UIAlertController?> {
		Binder(self.base) { from, destination in
			guard let destination = destination else {
				return
			}
			
			if from.navigationController != nil {
				from.navigationController?.present(destination, animated: true)
			} else {
				from.present(destination, animated: true, completion: nil)
			}
		}
	}
}
