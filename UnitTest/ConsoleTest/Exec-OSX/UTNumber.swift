/**
* @file		UTNumber.h
* @brief	Unit test for extension of NSNumber
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import Canary

public func UTNumber() -> Bool {
	var result = true
	
	print("* ObjCTypes")
	NSNumber.dumpObjCTypes()

	print("* kind() method test")
	result = dumpNumber("bool", num: NSNumber(bool: true)) && result
	result = dumpNumber("char", num: NSNumber(char: 15)) && result
	result = dumpNumber("short", num: NSNumber(short: 255)) && result
	result = dumpNumber("int", num: NSNumber(int: 1)) && result
	result = dumpNumber("long", num: NSNumber(long: 2)) && result
	result = dumpNumber("long long", num: NSNumber(longLong: 3)) && result
	
	result = dumpNumber("unsigned char", num: NSNumber(unsignedChar: 15)) && result
	result = dumpNumber("unsigned short", num: NSNumber(unsignedShort: 255)) && result
	result = dumpNumber("unsigned int", num: NSNumber(unsignedInt: 1)) && result
	result = dumpNumber("unsigned long", num: NSNumber(unsignedLong: 2)) && result
	result = dumpNumber("unsigned long long", num: NSNumber(unsignedLongLong: 3)) && result
	
	result = dumpNumber("float", num: NSNumber(float: 12.3)) && result
	result = dumpNumber("double", num: NSNumber(double: 12.34)) && result
	
	return result
}

private func dumpNumber(title: String, num : NSNumber) -> Bool{
	print("[\(title)] \t \(num) \t \(num.kind().toString()) \t \(num.toString())")
	return true
}
