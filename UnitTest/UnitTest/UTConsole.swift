/**
 * @file	UTConsole.swift
 * @brief	Unit test for CNConsole class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTConsoleTest() -> Bool
{
	let result0 = UTFileConsoleTest()
	let result1 = UTConnectedConsoleTest()
	return result0 && result1
}

private func UTFileConsoleTest() -> Bool
{
	let console = CNFileConsole(file: CNTextFile.stdout)
	console.print(string: "!!! Hello, World !!!\n")
	return true
}

private func UTConnectedConsoleTest() -> Bool
{
	let connection = CNConnection<String>()
	let outport    = CNOutputPort<String>()
	let inport     = CNInputPort<String>()
	let console    = CNConnectedConsole(outputPort: outport)
	outport.add(connection: connection)
	inport.add(connection: connection)
	inport.add(callback: {
		(_ data:String) -> Void in
		Swift.print(data, terminator:"")
	})
	console.print(string: "Good evening !!\n")
	return true
}

