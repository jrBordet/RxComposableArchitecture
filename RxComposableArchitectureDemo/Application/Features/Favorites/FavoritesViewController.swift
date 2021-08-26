//
//  FavoritesViewController.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import UIKit
import RxCocoa
import RxSwift
import RxComposableArchitecture

struct Favorite {
	var value: Int
}

class FavoritesViewController: UIViewController, StoreViewController {
	var store: Store<FavoritesState, FavoritesAction>?
	
	typealias Value = FavoritesState
	typealias Action = FavoritesAction
	
	@IBOutlet var tableView: UITableView!
	
	private let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let store = self.store else {
			fatalError()
		}
		
		tableView.rx
			.setDelegate(self)
			.disposed(by: disposeBag)
		
		tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
		
		store.state.debug("\(self)", trimOutput: false).subscribe().disposed(by: disposeBag)
				
		store.state
			.map { $0.favorites }
			.map { $0.map { Favorite(value: $0) } }
			.bind(to: tableView.rx.items(cellIdentifier: "FavoriteCell", cellType: FavoriteCell.self)) { row, item, cell in
				cell.numberLabel.text = String(item.value)
			}
			.disposed(by: disposeBag)
		
	}
}

extension FavoritesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
}
