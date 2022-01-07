////
////  ComposableArchitectureTestSupport.swift
////  RxPrimeTime
////
////  Created by Jean Raphael Bordet on 15/02/2020.
////  Copyright © 2020 Bordet. All rights reserved.
////
//
//import RxSwift
//import RxComposableArchitecture
//import XCTest
//import Difference
//
//public func XCTAssertEqual<T: Equatable>(_ expected: T, _ received: T, file: StaticString = #file, line: UInt = #line) {
//    XCTAssertTrue(expected == received, "Found difference for \n" + diff(received, expected).joined(separator: ", "), file: file, line: line)
//}
//
//public enum StepType {
//    case send
//    case sendSync
//    case receive
//}
//
//public final class TestStore<State, Action, Environment> {
//	private var environment: Environment
//	private let reducer: Reducer<State, Action, Environment>
//	private var state: State
//	
//	public init(
//		initialState: State,
//		reducer: Reducer<State, Action, Environment>,
//		environment: Environment
//		) {
//		self.state = initialState
//		self.reducer = reducer
//		self.environment = environment
//	}
//	
//}
//
//extension TestStore where Action: Equatable, State: Equatable {
//	public func assert(
//		steps: Step<State, Action>...,
//		file: StaticString = #file,
//		line: UInt = #line
//	) {
//		var state = self.state
//		var effects: [Effect<Action>] = []
//		let disposeBag = DisposeBag()
//		
//		steps.forEach { step in
//			var expected = state
//			
//			switch step.type {
//			case .send:
//				if effects.isEmpty == false {
//					XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
//				}
//				
//				effects.append(contentsOf: reducer(&state, step.action, environment))
//				
//			case .receive:
//				guard effects.isEmpty == false else {
//					XCTFail("No pending effects to receive from", file: step.file, line: step.line)
//					break
//				}
//				
//				let effect = effects.removeFirst()
//				var action: Action!
//				let receivedCompletion = XCTestExpectation(description: "receivedCompletion")
//				
//				effect
//					.subscribe(
//						onNext: { action = $0},
//						onCompleted: { receivedCompletion.fulfill() })
//					.disposed(by: disposeBag)
//				
//				if XCTWaiter.wait(for: [receivedCompletion], timeout: 1) != .completed {
//					XCTFail("Timed out waiting for the effect to complete", file: step.file, line: step.line)
//				}
//				
//				XCTAssertEqual(action, step.action, file: step.file, line: step.line)
//				
//				effects.append(contentsOf: reducer(&state, action, environment))
//				
//			case .sendSync:
//				if effects.isEmpty == false {
//					XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
//				}
//				
//				effects = []
//			}
//			
//			step.update(&expected)
//			
//			XCTAssertEqual(expected, state, file: step.file, line: step.line)
//		}
//		
//		if effects.isEmpty == false {
//			XCTFail("Assertion failed to handle \(effects.count) pending effect(s)", file: file, line: line)
//		}
//	}
//}
//
//public struct Step<Value, Action> {
//    let type: StepType
//    let action: Action
//    let update: (inout Value) -> Void
//    let file: StaticString
//    let line: UInt
//    
//    public init(
//        _ type: StepType,
//        _ action: Action,
//        file: StaticString = #file,
//        line: UInt = #line,
//        _ update: @escaping (inout Value) -> Void
//    ) {
//        self.type = type
//        self.action = action
//        self.update = update
//        self.file = file
//        self.line = line
//    }
//}
//
//public func assert<Value: Equatable, Action: Equatable, Environment>(
//    initialValue: Value,
//    reducer: Reducer<Value, Action, Environment>,
//    environment: Environment,
//    steps: Step<Value, Action>...,
//    file: StaticString = #file,
//    line: UInt = #line
//) {
//    var state = initialValue
//    var effects: [Effect<Action>] = []
//    let disposeBag = DisposeBag()
//    
//    steps.forEach { step in
//        var expected = state
//        
//        switch step.type {
//        case .send:
//            if effects.isEmpty == false {
//                XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
//            }
//            effects.append(contentsOf: reducer(&state, step.action, environment))
//            
//        case .receive:
//            guard effects.isEmpty == false else {
//                XCTFail("No pending effects to receive from", file: step.file, line: step.line)
//                break
//            }
//            
//            let effect = effects.removeFirst()
//            var action: Action!
//            let receivedCompletion = XCTestExpectation(description: "receivedCompletion")
//            
//            effect
//                .subscribe(
//                    onNext: { action = $0 },
//                    onCompleted: { receivedCompletion.fulfill() })
//                .disposed(by: disposeBag)
//            
//            if XCTWaiter.wait(for: [receivedCompletion], timeout: 1) != .completed {
//                XCTFail("Timed out waiting for the effect to complete", file: step.file, line: step.line)
//            }
//            
//            XCTAssertEqual(action, step.action, file: step.file, line: step.line)
//            
//            effects.append(contentsOf: reducer(&state, action, environment))
//            
//        case .sendSync:
//            if effects.isEmpty == false {
//                XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
//            }
//            
//            effects = []
//        }
//        
//        step.update(&expected)
//        
//        XCTAssertEqual(expected, state, file: step.file, line: step.line)
//    }
//    
//    if effects.isEmpty == false {
//        XCTFail("Assertion failed to handle \(effects.count) pending effect(s)", file: file, line: line)
//    }
//}
