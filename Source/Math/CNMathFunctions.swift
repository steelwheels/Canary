/**
* @file		CNMathFunctions.h
* @brief	Define basic mathematical functions
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation

public func clip <T:Comparable> (s0 : T, min:T, max:T) -> T {
	var result : T ;
	if s0 < min {
		result = min
	} else if s0 > max {
		result = max
	} else {
		result = s0
	}
	return result
}

