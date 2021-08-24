//
//  AppAction.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import Login

public enum AppAction: Equatable {
    case counter(CounterAction)
	case favorites(FavoritesAction)
}
