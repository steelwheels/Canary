/**
 * @file	UTNumber.swift
 * @brief	Unit test for NSNumber class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTNumber(console cons: CNConsole) -> Bool
{
	return numberKind(console: cons)
}

private func numberKind(console cons: CNConsole) -> Bool
{
	cons.print(string: "*** UTNumber: NSNumberKind\n")
	
	let result0  = checkNumberKind(number: NSNumber(value:	true), expectedKind: NSNumberKind.int8Number, console: cons)
	let result1  = checkNumberKind(number: NSNumber(value:	Int8(-1)), expectedKind: NSNumberKind.int8Number, console: cons)
	let result2  = checkNumberKind(number: NSNumber(value:	UInt8(1)), expectedKind: NSNumberKind.int16Number, console: cons)
	let result3  = checkNumberKind(number: NSNumber(value:	Int16(-1)), expectedKind: NSNumberKind.int16Number, console: cons)
	let result4  = checkNumberKind(number: NSNumber(value:	UInt16(1)), expectedKind: NSNumberKind.int32Number, console: cons)
	let result5  = checkNumberKind(number: NSNumber(value:	Int32(-1)), expectedKind: NSNumberKind.int32Number, console: cons)
	let result6  = checkNumberKind(number: NSNumber(value:	UInt32(1)), expectedKind: NSNumberKind.int64Number, console: cons)
	let result7  = checkNumberKind(number: NSNumber(value:	Int64(-1)), expectedKind: NSNumberKind.int64Number, console: cons)
	let result8  = checkNumberKind(number: NSNumber(value:	UInt64(1)), expectedKind: NSNumberKind.int64Number, console: cons)
	let result9  = checkNumberKind(number: NSNumber(value:	Float(1.2)), expectedKind: NSNumberKind.floatNumber, console: cons)
	let result10 = checkNumberKind(number: NSNumber(value:	Double(-2.3)), expectedKind: NSNumberKind.doubleNumber, console: cons)

	return result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 && result10
}

private func checkNumberKind(number num: NSNumber, expectedKind expkind: NSNumberKind, console cons: CNConsole) -> Bool
{
	let realkind = num.kind
	let realdesc = realkind.description
	let expdesc  = expkind.description

	let symbol = String(cString: num.objCType)
	let result = (realkind == expkind)

	var resstr: String
	if result {
		resstr = "=="
	} else {
		resstr = "!="
	}

	cons.print(string: "checkNumber: \(num.description) symbol:\(symbol) real:\(realdesc) \(resstr) expected:\(expdesc)\n")

	return result
}
