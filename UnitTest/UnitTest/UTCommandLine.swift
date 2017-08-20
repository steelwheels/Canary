/**
 * @file	UTCommandLine.swift
 * @brief	Unit test for CNCommandLine class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTCommandLine(console cons: CNConsole) -> Bool
{
	cons.print(string: "*** test0")
	let result0 = testCommandLine(strings: ["hello"], console: cons)
	cons.print(string: "*** test1")
	let result1 = testCommandLine(strings: ["--type0", "hello"], console: cons)
	cons.print(string: "*** test2")
	let result2 = testCommandLine(strings: ["--type1", "true", "hello"], console: cons)
	cons.print(string: "*** test3")
	let result3 = testCommandLine(strings: ["--type1", "true", "hello, world", "--type2", "1234"], console: cons)
	return result0 && result1 && result2 && result3
}

private func testCommandLine(strings strs: Array<String>, console cons: CNConsole) -> Bool
{
	let type0 = CNOptionType(id: 0, name: "type0", type: .VoidType)
	let type1 = CNOptionType(id: 1, name: "type1", type: .BooleanType)
	let type2 = CNOptionType(id: 2, name: "type2", type: .IntType)

	let result: Bool
	let parser = CNCommandLineManager(types: [type0, type1, type2])
	if parser.parse(inputStrings: strs) {
		let cmdline = parser.commandLine
		let text = cmdline.toText()
		text.print(console: cons, indent: 0)
		result = true
	} else {
		let errors = parser.errors
		for error in errors {
			Swift.print("[Error] \(error)")
		}
		result = false
	}
	return result
}
