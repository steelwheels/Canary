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
	let console = CNFileConsole(file: CNTextFile.stdout)
	console.print(string: "!!! Hello, World !!!\n")
	return true
}
