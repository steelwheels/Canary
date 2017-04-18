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
	let result0 = testCoder(text: "pi: 3.14")
	let result1 = testCoder(text: "pi: Double 3.14")
	let result2 = testCoder(text: "pi: Int 3.14")
	let result3 = testCoder(text: "ident0: Bool true")
	let result4 = testCoder(text: "{ident0: Int 1234}")
	let result5 = testCoder(text:     "{ident0: Int 1234\n"
					+ " ident1: Double 1.240 \n"
					+ "}")
	let result6 = testCoder(text: "{ident0: \"hello\"}")
	let result7 = testCoder(text: "command: %{ exit(0) ; %}")
	let summary = result0 && result1 && result2 && result3 && result4
	  && result5 && result6 && result7
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
