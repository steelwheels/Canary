//
//  UTMath.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/09/10.
//  Copyright 2016, 2017 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTMathTest() -> Bool
{
	let res0 = clipTest(value: 1.0, max: 3.0, min: 1.0)
	if res0 {
		print("[UTMath] OK")
		return true
	} else {
		print("[UTMath] NG")
		return false
	}
}

internal func clipTest<T: Comparable>(value v:T, max mx:T, min mn: T) -> Bool
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
	print("clip(value:\(v), max:\(mx), min:\(mn)) -> \(resstr)")
	return result
}
