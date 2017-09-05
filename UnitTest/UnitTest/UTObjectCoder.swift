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
	let result1  = testCoder(text: "pi: Double 3.14")
	let result2  = testCoder(text: "pi: Int 3.14")
	let result3  = testCoder(text: "ident0: Bool true")
	let result4  = testCoder(text: "dict0: C {ident0: Int 1234}")
	let result5  = testCoder(text:    "dict1: D {ident0: Int 1234\n"
					+ " ident1: Double 1.240 \n"
					+ "}")
	let result6  = testCoder(text: "dict0: C {ident0: String \"hello\"}")
	let result7  = testCoder(text: "command: Void %{ exit(0) ; %}")
	let result8  = testCoder(text: "rect: Size {width:Float 10.0 height:Float 22.2}")
	let result10 = testCoder(text: pattern10())
	let result11 = testCoder(text: pattern11())
	let summary = result1 && result2 && result3 && result4
	  && result5 && result6 && result7 && result8
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
	let input = "main_window: Window {\n"
		  + "  button0: Button { }\n"
		  + "  button1: Button { }\n"
		  + "}\n"
	return input
}

private func pattern11() -> String
{
	let input = "main_window: Window {\n"
		+ "  pressed: Void [self.exp0, self.exp1] %{"
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
		if let obj = object0 {
			let encoded = CNEncodeObjectNotation(notation: obj)
			print("RESULT: \(encoded)")
			result = true
		} else {
			print("[Error] Can not happen")
		}
	case .TokenizeError(let line, let message):
		print("[Error] \(message) at line \(line)")
	case .ParseError(let token, let message):
		print("[Error] \(message) at token \(token.description)")
	}
	return result
}
