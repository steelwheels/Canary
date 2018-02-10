/**
 * @file	UTJSONMatcher.swift
 * @brief	Unit test for CNJSONMatcher class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Canary
import Foundation

public func UTJSONMatcher(console cons: CNConsole) -> Bool
{
	do {
		let nexp1   = try NSRegularExpression(pattern: "name", options: [])
		let vexp1   = try NSRegularExpression(pattern: "value", options: [])
		let result1 =  testMatch(nameExpression: nexp1, valueExpression: vexp1, name: "name", value: "value", console: cons)
		let result2 = !testMatch(nameExpression: nexp1, valueExpression: vexp1, name: "eman", value: "value", console: cons)

		let nexp2   = try NSRegularExpression(pattern: "^n.*$", options: [])
		let vexp2   = try NSRegularExpression(pattern: "123", options: [])
		let val2    = NSNumber(integerLiteral: 123)
		let result3 =  testMatch(nameExpression: nexp2, valueExpression: vexp2, name: "name", value: val2, console: cons)
		return result1 && result2 && result3
	}
	catch {
		console.print(string: "Failed to generate regular expression")
		return false
	}
}

private func testMatch(nameExpression nexp: NSRegularExpression, valueExpression vexp: NSRegularExpression, name nm: String, value val: Any?, console cons: CNConsole) -> Bool
{
	console.print(string: "matching: key=\(nm) value=\(String(describing: val)) => ")
	let matcher = CNJSONMatcher(nameExpression: nexp, valueExpression: vexp)
	let result  = matcher.match(name: NSString(string: nm), anyObject: val)
	if result {
		console.print(string: "matched\n")
	} else {
		console.print(string: "Not matched\n")
	}
	return result
}

