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
	console.putString("Hello, world")
	console.putNewline()
	console.incIndent()
		console.putString("a")
		console.putString("b")
		console.putNewline()
	console.decIndent()
	console.putString("c")
	console.putNewline()
	
	return true
}
