/*
 * @file	UTValueTable.swift
 * @brief	Unit test for CNValueTable
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTValueTableTest(console cons: CNConsole) -> Bool
{
	let result0 = accessTest(console: cons)
	return result0
}

public func accessTest(console cons: CNConsole) -> Bool
{
	let table = CNValueTable()
	let values: Array<CNValue> = [
		CNValue(booleanValue: true),
		CNValue(characterValue: "c"),
		CNValue(intValue: -1234),
		CNValue(uIntValue: 2345),
		CNValue(floatValue: 12.3),
		CNValue(doubleValue: -34.5),
		CNValue(stringValue: "Hello")
	]

	var result = true
	for i in 0..<values.count {
		let elmres = testValueTable(console: cons, table: table, index:"v\(i)", value: values[i])
		result = result && elmres
	}

	return result0
}

private func testValueTable(console cons: CNConsole, table tbl: CNValueTable, index idx: String, value val: CNValue) -> Bool
{
	console.print(string: "idx=\"\(idx)\", value=\"\(val.description)\" ... ")
	if let _ = tbl.property(index: idx) {
		cons.print(string: "[Error] Already exist: \(idx)\n")
		return false
	}

	tbl.setProperty(index: idx, value: val)

	if let retval = tbl.property(index: idx) {
		let compe = retval == val
		let compn = retval != val
		let compl = retval <  val
		let compg = retval >  val
		if compe && !compn && !compl && !compg {
			cons.print(string: "OK\n")
		} else {
			cons.print(string: "[Error] Not same object: \(idx)\n")
			return false
		}
	} else {
		cons.print(string: "[Error] Not exist: \(idx)\n")
		return false
	}

	return true
}
