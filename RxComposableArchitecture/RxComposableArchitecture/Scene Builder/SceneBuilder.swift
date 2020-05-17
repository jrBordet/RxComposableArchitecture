//
//  SceneBuilder.swift
//  SceneBuilder
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import UIKit

public struct Scene<A: UIViewController> {
    public init () { }
    
    public func render() -> A {
        guard let nib = (String(describing: type(of: self)) as NSString).components(separatedBy: ".").first else {
            fatalError()
        }
        
        let nibName = nib.replacingOccurrences(of: "Scene<", with: "").dropLast()
        
        let vc = A(nibName: String(nibName), bundle: Bundle(for: A.self))
        
        return vc
    }
    
    public func nib() -> String {
        guard let nib = (String(describing: type(of: self)) as NSString).components(separatedBy: ".").first else {
            fatalError()
        }
        
        return String(nib.replacingOccurrences(of: "Scene<", with: "").dropLast())
    }
    
    public func bundle() -> Bundle {
        return Bundle(for: A.self)
    }
}

public func navigationLink<A: UIViewController>(from vc: UIViewController, destination: Scene<A>, completion: (A) -> Void, isModal: Bool =  false) -> Void {
    let to = destination.render()
    
    if isModal {
        completion(to)
        
        vc.present(to, animated: true)
        return
    }
    
    vc.navigationController?.pushViewController(to, animated: true)
    
    completion(to)
}
