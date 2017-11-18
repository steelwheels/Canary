/**
 * @file	UTConsole.swift
 * @brief	Unit test for CNConsole class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTConsoleTest(console cons: CNConsole) -> Bool
{
	testConsole(console: cons)
	let result = testPipeConsole(console: cons)
	return result
}

private func testConsole(console cons: CNConsole)
{
	cons.print(string: "this is print message\n")
	cons.error(string: "this is error message\n")
}

private class UTPipeConsole: CNConsole
{
	private var mConsole: CNConsole

	public init(console cons: CNConsole) {
		mConsole = cons
	}

	open override func print(string str: String){
		mConsole.print(string: "UTPipeConsole(P): \"\(str)\"\n")
	}

	open override func error(string str: String){
		mConsole.print(string: "UTPipeConsole(E): \"\(str)\"\n")
	}

	var didscanned = false
	open override func scan() -> String? {
		sleep(1)
		if didscanned {
			return nil
		} else {
			didscanned = true
			return "UTPipeConsole(S): Scanned data"
		}
	}
}

private func testPipeConsole(console cons: CNConsole) -> Bool
{
	var result = true

	let inputdata = String("hello, world").data(using: .utf8)!
	sleep(1)
	let errordata = String("Error message").data(using: .utf8)!
	sleep(1)
	
	let pipecons = CNPipeConsole()
	pipecons.toConsole = UTPipeConsole(console: cons)
	pipecons.inputPipe.fileHandleForWriting.write(inputdata)
	pipecons.errorPipe.fileHandleForWriting.write(errordata)

	let rdata = pipecons.outputPipe.fileHandleForReading.readData(ofLength: 10)
	if let rstr = String(data: rdata, encoding: .utf8) {
		cons.print(string: "Read data: \(rstr)\n")
	} else {
		cons.print(string: "Error: No read data\n")
		result = false
	}
	return result
}



