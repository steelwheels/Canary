/**
 * @file	UTTriState.swift
 * @brief	Unit test for CNTriState class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTTristateTest(console cons: CNConsole) -> Bool
{
	printTristate(state: .Unknown, console: cons)
	return true
}

internal func printTristate(state stat: CNTristate, console cons: CNConsole)
{
	cons.print(string: "state = \(stat.description)\n")
}

