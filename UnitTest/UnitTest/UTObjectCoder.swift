/**
 * @file	UTObjectCoder.swift
 * @brief	Unit test for CNObjectCoder class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTObjectCoder() -> Bool
{
	let result0 = testCoder(text: "ident0: Bool true")
	let result1 = testCoder(text: "{ident0: Int 1234}")
	let result2 = testCoder(text:     "{ident0: Int 1234\n"
					+ " ident1: Float 1.240 \n"
					+ "}")
	let result3 = testCoder(text: "{ident0: \"hello\"}")
	let summary = result0 && result1 && result2 && result3
	return summary
}

private func testCoder(text txt: String) -> Bool
{
	var result = false
	print("[Input] \(txt)")
	let (err0, object0) = CNDecodeObjectNotation(text: txt)
	switch err0 {
	case .NoError:
		if let obj = object0 {
			let encoded = CNEncodeObjectNotation(notation: obj)
			print("RESULT: \(encoded)")
			result = true
		} else {
			print("[Error] Can not happen")
		}
	case .ParseError(let line, let message):
		print("[Error] \(message) at line \(line)")
	}
	return result
}
