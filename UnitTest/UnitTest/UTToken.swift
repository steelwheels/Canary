/**
 * @file	UTToken.swift
 * @brief	Unit test for CNToken class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTTokenTest(console cons: CNConsole) -> Bool
{
	var result = true
	result = result && testToken(text: "()", expectedResult: true, expectedNum: 2, console: cons)
	result = result && testToken(text: "0", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "0 0xff", expectedResult: true, expectedNum: 2, console: cons)
	result = result && testToken(text: "0 0xa 0.123", expectedResult: true, expectedNum: 3, console: cons)
	result = result && testToken(text: "321", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "-321", expectedResult: true, expectedNum: 2, console: cons)
	result = result && testToken(text: "1 Hello0 2", expectedResult: true, expectedNum: 3, console: cons)
	result = result && testToken(text: "\"a\"", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "0 \"a\" \"b\" 1", expectedResult: true, expectedNum: 4, console: cons)
	result = result && testToken(text: "0 \"a\" \"b\" \"c\" 1", expectedResult: true, expectedNum: 5, console: cons)
	result = result && testToken(text: "\"\"", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "\"\\\"\"", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "\"\\\\\"", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "\"hello", expectedResult: false, expectedNum: 1, console: cons)
	result = result && testToken(text: "%{ abc %}", expectedResult: true, expectedNum: 1, console: cons)
	result = result && testToken(text: "rect: Size {width:10.0 height:22.2}", expectedResult: true, expectedNum: 11, console: cons)
	return true
}

private func testToken(text txt: String, expectedResult expres: Bool, expectedNum expnum: Int, console cons: CNConsole) -> Bool
{
	cons.print(string: "Source: \"\(txt)\"\n")

	let (error, tokens) = CNStringToToken(string: txt)
	var realres: Bool
	switch error {
	case .NoError:
		cons.print(string: "result -> \n")
		var i: Int = 0
		for token in tokens {
			print("  \(i): \(token.description)")
			i += 1
		}
		realres = (tokens.count == expnum)
	case .TokenizeError(_, _), .ParseError(_, _):
		let desc = error.description()
		cons.print(string: "result -> \(desc)\n")
		realres = false
	}
	let result = realres == expres
	if result {
		cons.print(string: "  => OK\n")
	} else {
		cons.print(string: "  => NG\n")
	}
	return result
}


