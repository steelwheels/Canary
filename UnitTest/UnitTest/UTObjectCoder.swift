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
	let result0  = testCoder(text: "pi: 3.14")
	let result1  = testCoder(text: "pi: Double 3.14")
	let result2  = testCoder(text: "pi: Int 3.14")
	let result3  = testCoder(text: "ident0: Bool true")
	let result4  = testCoder(text: "{ident0: Int 1234}")
	let result5  = testCoder(text:     "{ident0: Int 1234\n"
					+ " ident1: Double 1.240 \n"
					+ "}")
	let result6  = testCoder(text: "{ident0: \"hello\"}")
	let result7  = testCoder(text: "command: %{ exit(0) ; %}")
	let result8  = testCoder(text: "rect: Size {width:10.0 height:22.2}")
	let result9  = testCoder(text: "arr: [1,2, 3]")
	let result10 = testCoder(text: pattern10())
	let result11 = testCoder(text: pattern11())
	let summary = result0 && result1 && result2 && result3 && result4
	  && result5 && result6 && result7 && result8 && result9
	  && result10 && result11
	if summary {
		print("[UTObjectCoder] Summary: OK")
	} else {
		print("[UTObjectCoder] Summary: NG")
	}
	return summary
}

private func pattern10() -> String
{
	let input = "{\n"
		  + "  button0: Button { }\n"
		  + "  button1: Button { }\n"
		  + "}\n"
	return input
}

private func pattern11() -> String
{
	let input = "{\n"
		+ "  pressed: (self.exp0, self.exp1) %{"
		+ "    echo(\"Hello, World\"); "
		+ "  %}\n"
		+ "}\n"
	return input
}

private func testCoder(text txt: String) -> Bool
{
	var result = false
	print("[Input] \(txt)")
	let (err0, object0) = CNDecodeObjectNotation(text: txt)
	switch err0 {
	case .NoError:
		for obj in object0 {
			let encoded = CNEncodeObjectNotation(notation: obj)
			print("RESULT: \(encoded)")
			result = true
		}
	case .TokenizeError(let line, let message):
		print("[Error] \(message) at line \(line)")
	case .ParseError(let token, let message):
		print("[Error] \(message) at token \(token.description)")
	}
	return result
}
