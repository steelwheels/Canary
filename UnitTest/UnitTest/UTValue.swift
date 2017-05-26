/**
 * @file	UTValue.swift
 * @brief	Unit test for CNValue class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Canary

public func UTValueTest() -> Bool
{
	var result = true

	let val0: CNValue = CNValue(booleanValue: true)
	print("val0 = \(val0.typeDescription):\(val0.description)")

	let val1: CNValue = CNValue(intValue: -123)
	print("val1 = \(val1.typeDescription):\(val1.description)")

	let val2: CNValue = CNValue(uIntValue: 0xff)
	print("val2 = \(val2.typeDescription):\(val2.description)")

	let val3: CNValue = CNValue(floatValue: 0.123)
	print("val3 = \(val3.typeDescription):\(val3.description)")

	let val4: CNValue = CNValue(doubleValue: -1.23)
	print("val4 = \(val4.typeDescription):\(val4.description)")

	let val5: CNValue = CNValue(arrayValue: [val0, val1])
	print("val5 = \(val5.typeDescription):\(val5.description)")

	let val6: CNValue = CNValue(setValue: [val0, val1, val0])
	//print("val6 = \(val6.typeDescription):\(val6.description)")

	let val7: CNValue = CNValue(dictionaryValue: ["a":val0, "b":val1])
	print("val7 = \(val7.typeDescription):\(val7.description)")

	let val8: CNValue = CNValue(dictionaryValue: ["a":val1, "b":val2])
	print("val8 = \(val8.typeDescription):\(val8.description)")

	result = result && compare(expected: true,  val0: val0, val1: val0)
	result = result && compare(expected: false, val0: val0, val1: val1)
	result = result && compare(expected: true,  val0: val5, val1: val5)
	result = result && compare(expected: true,  val0: val6, val1: val6)
	result = result && compare(expected: true,  val0: val7, val1: val7)
	result = result && compare(expected: false,  val0: val7, val1: val8)

	if let val1f = val1.cast(to: .FloatType) {
		print("val1f = \(val1f.typeDescription):\(val1f.description)")
	} else {
		print("[Error] val1f = nil")
	}

	return result
}

private func compare(expected exp: Bool, val0: CNValue, val1: CNValue) -> Bool {
	var issame: Bool
	if val0 == val1 {
		issame = true
	} else {
		issame = false
	}

	if (exp && issame) || (!exp && !issame) {
		return true
	} else {
		return false
	}
}
