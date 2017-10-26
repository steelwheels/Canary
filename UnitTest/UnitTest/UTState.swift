/**
 * @file	UTState.swift
 * @brief	Unit test for CNState class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

internal class UTState : CNState
{
	public enum Factor: Int {
		case ValueFactor	= 123
	}

	private var mConsole: CNConsole
	private var mValue: Int
	
	init(newval: Int, console cons: CNConsole){
		mValue   = newval
		mConsole = cons
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
			mConsole.print(string: "set new value: \(mValue)\n")
			updateState(factorValue: Factor.ValueFactor.rawValue)
		}
	}
}

public func UTStateTest(console cons: CNConsole) -> Bool
{
	testNormalState(console: cons)
	testCombinedState(console: cons)
	return true
}

internal func testNormalState(console cons: CNConsole)
{
	cons.print(string: "* Start: testNormalState\n")
    let s0 = UTState(newval: 0, console: cons)
	let observer0 = CNStateObserver()
	observer0.state = s0
	observer0.callback = { (state : CNState) -> Void in
		if let s = state as? UTState {
			cons.print(string: "Observed state value = \(s.value), factor = \(s.factor.rawValue)\n")
		} else {
			fatalError("Invalid state class\n")
		}
	}
	s0.value = 1
	cons.print(string: "* Done: testNormalState\n")
}

internal func testCombinedState(console cons: CNConsole)
{
	cons.print(string: "* Start: testCombinedState\n")
	
	let s0 = UTState(newval:  0, console: cons)
	let s1 = UTState(newval: 10, console: cons)
	let sc = CNCombinedState()
	sc.addSourceState(state: s0)
	sc.addSourceState(state: s1)
	
	let observer0 = CNStateObserver()
	observer0.state = sc
	observer0.callback = { (state : CNState) -> Void in
		cons.print(string: "Observe combined values\n")
		if let comb = state as? CNCombinedState {
			for child in comb.sourceStates {
				if let cstate = child as? UTState {
					cons.print(string: "Observed state value = \(cstate.value)\n")
				} else {
					fatalError("Invalid state class (1)\n")
				}
			}
		} else {
			fatalError("Invalid state class (2)\n")
		}
	}
	s0.value = 1
	s1.value = 11
	
	cons.print(string: "* End: testCombinedState\n")
}

