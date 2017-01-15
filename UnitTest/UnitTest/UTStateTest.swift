//
//  UTStateTest.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/02/24.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

internal class UTState : CNState
{
	public enum Factor: Int {
		case ValueFactor	= 123
	}

	private var mValue: Int
	
	init(newval: Int){
		mValue = newval
	}

	public var factor: Factor {
		if let f = Factor(rawValue: factorValue) {
			return f
		} else {
			fatalError("Invalid factor value")
		}
	}

	internal var value: Int {
		get {
			return mValue
		}
		set(newval){
			mValue = newval
			print("set new value: \(mValue)")
			updateState(factorValue: Factor.ValueFactor.rawValue)
		}
	}
}

public func UTStateTest() -> Bool
{
	testNormalState()
	testCombinedState()
	return true
}

internal func testNormalState()
{
	print("* Start: testNormalState")
	let s0 = UTState(newval: 0)
	let observer0 = CNStateObserver()
	observer0.state = s0
	observer0.callback = { (state : CNState) -> Void in
		if let s = state as? UTState {
			print("Observed state value = \(s.value), factor = \(s.factor.rawValue)")
		} else {
			fatalError("Invalid state class")
		}
	}
	s0.value = 1
	print("* Done: testNormalState")
}

internal func testCombinedState()
{
	print("* Start: testCombinedState")
	
	let s0 = UTState(newval:  0)
	let s1 = UTState(newval: 10)
	let sc = CNCombinedState()
	sc.addSourceState(state: s0)
	sc.addSourceState(state: s1)
	
	let observer0 = CNStateObserver()
	observer0.state = sc
	observer0.callback = { (state : CNState) -> Void in
		print("Observe combined values")
		if let comb = state as? CNCombinedState {
			for child in comb.sourceStates {
				if let cstate = child as? UTState {
					print("Observed state value = \(cstate.value)")
				} else {
					fatalError("Invalid state class (1)")
				}
			}
		} else {
			fatalError("Invalid state class (2)")
		}
	}
	s0.value = 1
	s1.value = 11
	
	print("* End: testCombinedState")
}

