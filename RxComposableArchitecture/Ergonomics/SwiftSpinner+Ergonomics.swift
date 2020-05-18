//
//  SwiftSpinner+Ergonomics.swift
//  RxComposableArchitecture
//
//  Created by Jean Raphael Bordet on 15/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import RxSwift
import RxCocoa
//import SwiftSpinner

extension Reactive where Base: UIView {
    /// Bindable sink for `hidden` property.
    public var isVisible: Binder<Bool> {
        return Binder(self.base) { view, visible in
            view.isHidden = visible == false
        }
    }
}
