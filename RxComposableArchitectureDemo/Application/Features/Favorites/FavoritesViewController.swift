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

class FavoritesViewController: UIViewController {
	@IBOutlet var tableView: UITableView!
	
	let viewStore: ViewStore<FavoritesState, FavoritesAction>
	var disposeBag = DisposeBag()
	
	init(store: Store<FavoritesState, FavoritesAction>) {
		self.viewStore = ViewStore(store)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rx
			.setDelegate(self)
			.disposed(by: disposeBag)
		
		tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
				
		viewStore.publisher
			.map { $0.favorites }
			.map { $0.map { Favorite(value: $0) } }
			.bind(to: tableView.rx.items(cellIdentifier: "FavoriteCell", cellType: FavoriteCell.self)) { row, item, cell in
				cell.numberLabel.text = String(item.value)
			}
			.disposed(by: disposeBag)
		
		tableView.rx
			.itemSelected
			.do(afterNext: { [weak self] _ in
				guard let self = self else {
					return
				}
				
				self.viewStore.send(.trivia)
			})
			.map { $0.row }
			.bind { [weak self] in self?.viewStore.send(FavoritesAction.selectAt($0)) }
			.disposed(by: disposeBag)
		
		viewStore.publisher
			.map { $0.trivia }
			.distinctUntilChanged()
			.ignoreNil()
			.messageAlertController { }
			.bind(to: self.rx.presentAlert)
			.disposed(by: disposeBag)
		
	}
}

extension FavoritesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
}
