//
//  UTNumber.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/08/20.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTNumber() -> Bool
{
	return numberKind()
}

private func numberKind() -> Bool
{
	print("*** UTNumber: NSNumberKind")
	
	let result0  = checkNumberKind(number: NSNumber(value:	true), expectedKind: NSNumberKind.booleanNumber)
	let result1  = checkNumberKind(number: NSNumber(value:	Int8(-1)), expectedKind: NSNumberKind.int8Number)
	let result2  = checkNumberKind(number: NSNumber(value:	UInt8(1)), expectedKind: NSNumberKind.int16Number)
	let result3  = checkNumberKind(number: NSNumber(value:	Int16(-1)), expectedKind: NSNumberKind.int16Number)
	let result4  = checkNumberKind(number: NSNumber(value:	UInt16(1)), expectedKind: NSNumberKind.int32Number)
	let result5  = checkNumberKind(number: NSNumber(value:	Int32(-1)), expectedKind: NSNumberKind.int32Number)
	let result6  = checkNumberKind(number: NSNumber(value:	UInt32(1)), expectedKind: NSNumberKind.int64Number)
	let result7  = checkNumberKind(number: NSNumber(value:	Int64(-1)), expectedKind: NSNumberKind.int64Number)
	let result8  = checkNumberKind(number: NSNumber(value:	UInt64(1)), expectedKind: NSNumberKind.int64Number)
	let result9  = checkNumberKind(number: NSNumber(value:	Float(1.2)), expectedKind: NSNumberKind.floatNumber)
	let result10 = checkNumberKind(number: NSNumber(value:	Double(-2.3)), expectedKind: NSNumberKind.doubleNumber)

	return result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 && result10
}

private func checkNumberKind(number num: NSNumber, expectedKind expkind: NSNumberKind) -> Bool
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

	print("checkNumber: \(num.description) symbol:\(symbol) real:\(realdesc) \(resstr) expected:\(expdesc)")

	return result
}
