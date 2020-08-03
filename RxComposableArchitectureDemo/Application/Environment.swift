//
//  Environment.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation

public typealias AppEnvironment = (
  counter: CounterViewEnvironment,
  other: () -> ()
)

let counterEnv: CounterViewEnvironment = (
    counter: { _ in .sync { 5 } },
    other: { .sync { true } }
)

let live: AppEnvironment = (
    counter: counterEnv,
    other: { }
)
