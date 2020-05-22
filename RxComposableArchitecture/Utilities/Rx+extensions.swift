//
//  Rx+extensions.swift
//  RxPrimeTime
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftSpinner

extension Reactive where Base: UIView {
    /// Bindable sink for `hidden` property.
    public var isVisible: Binder<Bool> {
        return Binder(self.base) { view, visible in
            view.isHidden = visible == false
        }
    }
}

extension SwiftSpinner {
    public var rx_progress: AnyObserver<Double> {
        return Binder(self) { spinner, progress in
            let p = max(0, min(progress, 100))
            
            SwiftSpinner.show(delay: p, title: "\(p)%", animated: true)
            }.asObserver()
    }
    
    public var rx_visible: AnyObserver<Bool> {
        return Binder(self) { spinner, value in
            if value {
                SwiftSpinner.show("loading", animated: true)
            } else {
                SwiftSpinner.hide()
            }}.asObserver()
    }
}

