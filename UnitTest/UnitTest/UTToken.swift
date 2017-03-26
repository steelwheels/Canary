//  UTToken.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/09/10.
//  Copyright (C) 2016, 2017 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTTokenTest() -> Bool
{
	var result = true
	result = result && testToken(text: "()", expectedResult: true, expectedNum: 2)
	result = result && testToken(text: "0", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "0 0xff", expectedResult: true, expectedNum: 2)
	result = result && testToken(text: "0 0xa 0.123", expectedResult: true, expectedNum: 3)
	result = result && testToken(text: "321", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "-321", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "1 Hello0 2", expectedResult: true, expectedNum: 3)
	result = result && testToken(text: "\"a\"", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "0 \"a\" \"b\" 1", expectedResult: true, expectedNum: 3) // "a", "b" -> "ab"
	result = result && testToken(text: "0 \"a\" \"b\" \"c\" 1", expectedResult: true, expectedNum: 3) // "a", "b", "c" -> "abc"
	result = result && testToken(text: "\"\"", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "\"\\\"\"", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "\"\\\\\"", expectedResult: true, expectedNum: 1)
	result = result && testToken(text: "\"hello", expectedResult: false, expectedNum: 1)
	return true
}

private func testToken(text txt: String, expectedResult expres: Bool, expectedNum expnum: Int) -> Bool
{
	print("Source: \"\(txt)\"")

	let (error, tokens) = CNStringToToken(string: txt)
	var realres: Bool
	switch error {
	case .NoError:
		print("result -> ")
		var i: Int = 0
		for token in tokens {
			print("  \(i): \(token.description())")
			i += 1
		}
		realres = (tokens.count == expnum)
	case .ParseError(_, _):
		let desc = error.description()
		print("result -> \(desc)")
		realres = false
	}
	let result = realres == expres
	if result {
		print("  => OK")
	} else {
		print("  => NG")
	}
	return result
}


