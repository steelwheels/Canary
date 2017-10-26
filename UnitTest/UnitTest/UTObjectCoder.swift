/**
 * @file	UTObjectCoder.swift
 * @brief	Unit test for CNObjectCoder class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTObjectCoder(console cons: CNConsole) -> Bool
{
    let result1  = testCoder(text: "pi: Double 3.14", console: cons)
	let result2  = testCoder(text: "pi: Int 3.14", console: cons)
	let result3  = testCoder(text: "ident0: Bool true", console: cons)
	let result4  = testCoder(text: "dict0: C {ident0: Int 1234}", console: cons)
	let result5  = testCoder(text:    "dict1: D {ident0: Int 1234\n"
					+ " ident1: Double 1.240 \n"
					+ "}", console: cons)
	let result6  = testCoder(text: "dict0: C {ident0: String \"hello\"}", console: cons)
	let result7  = testCoder(text: "command: Void %{ exit(0) ; %}", console: cons)
	let result8  = testCoder(text: "rect: Size {width:Float 10.0 height:Float 22.2}", console: cons)
	let result10 = testCoder(text: pattern10(), console: cons)
	let result11 = testCoder(text: pattern11(), console: cons)
	let summary = result1 && result2 && result3 && result4
	  && result5 && result6 && result7 && result8
	  && result10 && result11
	if summary {
        cons.print(string: "[UTObjectCoder] Summary: OK\n")
	} else {
        cons.print(string: "[UTObjectCoder] Summary: NG\n")
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

private func testCoder(text txt: String, console cons: CNConsole) -> Bool
{
	var result = false
    cons.print(string: "[Input] \(txt)\n")
	let (err0, object0) = CNDecodeObjectNotation(text: txt)
	switch err0 {
	case .NoError:
		if let obj = object0 {
			let encoded = CNEncodeObjectNotation(notation: obj)
            cons.print(string: "RESULT: \(encoded)\n")
			result = true
		} else {
            cons.print(string: "[Error] Can not happen\n")
		}
	case .TokenizeError(let line, let message):
        cons.print(string: "[Error] \(message) at line \(line)\n")
	case .ParseError(let token, let message):
        cons.print(string: "[Error] \(message) at token \(token.description)\n")
	}
	return result
}
