/**
* @file		UTClassUtil.h
* @brief	Unit test for CNClassUtil class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import Canary

public func UTClassUtil() -> Bool
{
	printTypeName(1)
	printTypeName(NSString(string: "hello"))
	printTypeName(CNTextSection())
	return true
}

private func printTypeName(obj : AnyObject)
{
	let name = CNTypeName(obj)
	print("name: \"\(name)\"")
}
