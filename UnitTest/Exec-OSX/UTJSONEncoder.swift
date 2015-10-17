/**
* @file		UTJSONEncoder.h
* @brief	Unit test for CNJSONEncoder class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import Canary

public func UTJSONEncoder() -> Bool
{
	let console = CNTextConsole()
	
	print("* number")
	let num0 = NSNumber(bool: true)
	dumpObject(console, obj: num0)
	
	print("* string")
	let str0 = NSString(string: "Hello")
	dumpObject(console, obj: str0)
	
	print("* array")
	let num1 = NSNumber(integer: 1234)
	let arr0 = NSArray(array: [num0, num1])
	dumpObject(console, obj: arr0)
	
	print("* dictionary")
	let dict0 : Dictionary = ["a":num0, "b":num1, "c":arr0]
	dumpObject(console, obj: dict0)
	
	return true
}

private func dumpObject(console : CNConsole, obj : NSObject)
{
	let jencoder = CNJSONEncoder()
	let text = jencoder.encode(obj)
	let tdumper = CNTextDumper()
	tdumper.dumpToConsole(console, text: text)
}
