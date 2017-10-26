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
	let console = CNConsole()
	testConsole(console: console)
	return true
}

private func testConsole(console cons: CNConsole)
{
	cons.print(string: "this is print message\n")
	cons.error(string: "this is error message\n")
}



