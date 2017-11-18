/**
 * @file	UTValue.swift
 * @brief	Unit test for CNValue class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Canary

public func UTValueTest(console cons: CNConsole) -> Bool
{
	cons.print(string: "[UTValue] Constructers\n")
	let result0 = UTValueConstructorTest(console: cons)
	cons.print(string: "[UTValue] Converter\n")
	let result1 = UTValueConverterTest(console: cons)
	return result0 && result1
}

private func UTValueConstructorTest(console cons: CNConsole) -> Bool
{
	var result = true

	let val0: CNValue = CNValue(booleanValue: true)
	cons.print(string: "val0 = \(val0.typeDescription):\(val0.description)\n")

	let val1: CNValue = CNValue(intValue: -123)
	cons.print(string: "val1 = \(val1.typeDescription):\(val1.description)\n")

	let val2: CNValue = CNValue(uIntValue: 0xff)
	cons.print(string: "val2 = \(val2.typeDescription):\(val2.description)\n")

	let val3: CNValue = CNValue(floatValue: 0.123)
	cons.print(string: "val3 = \(val3.typeDescription):\(val3.description)\n")

	let val4: CNValue = CNValue(doubleValue: -1.23)
	cons.print(string: "val4 = \(val4.typeDescription):\(val4.description)\n")

	let val5: CNValue = CNValue(arrayValue: [val0, val1])
	cons.print(string: "val5 = \(val5.typeDescription):\(val5.description)\n")

	let val7: CNValue = CNValue(dictionaryValue: ["a":val0, "b":val1])
	cons.print(string: "val7 = \(val7.typeDescription):\(val7.description)\n")

	let val8: CNValue = CNValue(dictionaryValue: ["a":val1, "b":val2])
	cons.print(string: "val8 = \(val8.typeDescription):\(val8.description)\n")

	let val9: CNValue = CNValue(dictionaryValue: ["b":val2, "a":val1])
	cons.print(string: "val9 = \(val9.typeDescription):\(val9.description)\n")

	let val10: CNValue = CNValue(characterValue: "A")
	cons.print(string: "val10 = \(val10.typeDescription):\(val10.description)\n")

	let val11: CNValue = CNValue(characterValue: "A")
	cons.print(string: "val11 = \(val11.typeDescription):\(val11.description)\n")

	result = result && compare(title:"c0", expected: true,  val0: val0, val1: val0, console: cons)
	result = result && compare(title:"c1", expected: false, val0: val0, val1: val1, console: cons)
	result = result && compare(title:"c2", expected: true,  val0: val5, val1: val5, console: cons)
	result = result && compare(title:"c4", expected: true,  val0: val7, val1: val7, console: cons)
	result = result && compare(title:"c5", expected: false, val0: val7, val1: val8, console: cons)
	result = result && compare(title:"c6", expected: true, val0: val9, val1: val8, console: cons)
	result = result && compare(title:"c7", expected: true,  val0: val10, val1: val11, console: cons)

	if let val1f = val1.cast(to: .FloatType) {
		cons.print(string: "val1f = \(val1f.typeDescription):\(val1f.description)\n")
	} else {
		cons.print(string: "[Error] val1f = nil\n")
	}

	return result
}

private func compare(title titl:String, expected exp: Bool, val0: CNValue, val1: CNValue, console cons: CNConsole) -> Bool
{
	var issame: Bool
	if val0 == val1 {
		issame = true
	} else {
		issame = false
	}

	if (exp && issame) || (!exp && !issame) {
		return true
	} else {
		cons.print(string: "TEST: \(titl) was failed\n")
		return false
	}
}

private func UTValueConverterTest(console cons: CNConsole) -> Bool
{
	convert(targetType: .BooleanType, string: "true")
	convert(targetType: .CharacterType, string: "A")
	convert(targetType: .IntType, string: "-123")
	convert(targetType: .UIntType, string: "0xff")
	convert(targetType: .FloatType, string: "-1.23")
	convert(targetType: .DoubleType, string: "0.01")
	convert(targetType: .StringType, string: "Hello, world")
	return true
}

private func convert(targetType type: CNValueType, string str: String)
{
	let typestr = type.description
	if let val = CNStringToValue(targetType: type, string: str) {
		let desc = val.description
		console.print(string: "convert from \"\(str)\" to type \(typestr) -> \"\(desc)\"\n")
	} else {
		console.print(string: "convert from \"\(str)\" to type \(typestr) -> failed\n")
	}
}

