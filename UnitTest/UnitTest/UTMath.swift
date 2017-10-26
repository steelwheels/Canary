/**
 * @file	UTMath.swift
 * @brief	Unit test for math functions
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTMathTest(console cons: CNConsole) -> Bool
{
    let res0 = clipTest(value: 1.0, max: 3.0, min: 1.0, console: cons)
	if res0 {
        cons.print(string: "[UTMath] OK\n")
		return true
	} else {
        cons.print(string: "[UTMath] NG\n")
		return false
	}
}

internal func clipTest<T: Comparable>(value v:T, max mx:T, min mn: T, console cons: CNConsole) -> Bool
{
	var expval: T
	if v > mx {
		expval = mx
	} else if v < mn {
		expval = mn
	} else {
		expval = v
	}

	let realval = clip(value: v, max: mx, min: mn)
	let result  = (expval == realval)
	let resstr: String
	if result {
		resstr = "\(realval) -> OK"
	} else {
		resstr = "\(realval) != \(expval) -> NG"
	}
    cons.print(string: "clip(value:\(v), max:\(mx), min:\(mn)) -> \(resstr)\n")
	return result
}
