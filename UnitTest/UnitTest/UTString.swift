/**
 * @file	UTString.swift
 * @brief	Unit test for CNString class
 * @par Copyright
 *   Copyright (C) 2016^2018 Steel Wheels Project
 */

import Foundation
import Canary

public func UTString(console cons: CNConsole) -> Bool
{
	let result0 = testStringDivider(console: cons)
	return result0
}

private func testStringDivider(console cons: CNConsole) -> Bool
{
	let result0 = testStringDivider(string: "Hello, world", console: cons)
	let result1 = testStringDivider(string: "\"Hello, world\"", console: cons)
	let result2 = testStringDivider(string: "Hell\"o, w\"orld", console: cons)
	let result3 = testStringDivider(string: "Hell\\\"o, world", console: cons)
	let result4 = testStringDivider(string: " 1  2   3    4", console: cons)
	return result0 && result1 && result2 && result3 && result4
}

private func testStringDivider(string src: String, console cons: CNConsole) -> Bool
{
	cons.print(string: "src-string: \"\(src)\" -> ")
	let substrs = CNStringUtil.divideByQuote(sourceString: src, quote: "\"")
	cons.print(string: "\(substrs)\n")
	return true
}


