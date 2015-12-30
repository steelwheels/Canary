/**
 * @file	UTTextConsole.h
 * @brief	Unit test for CNTextConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Canary

public func UTTextConsole() -> Bool
{
	let console = CNTextConsole()
	console.printLine("1line string")
	console.printLines(["1st line of 2", "2nd line of 2"])
	return true
}
