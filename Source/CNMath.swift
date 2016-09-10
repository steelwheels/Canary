/**
 * @file	CNMath.h
 * @brief	Define arithmetic functions
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public func pow(base b:Int, power p:UInt) -> Int
{
	var result : Int = 1
	for _ in 0..<p {
		result *= b
	}
	return result
}

public func clip<T: Comparable>(value v:T, max mx:T, min mn: T) -> T
{
	var result: T
	if v < mn {
		result = mn
	} else if v > mx {
		result = mx
	} else {
		result = v
	}
	return result
}

