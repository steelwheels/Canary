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
	console.addWord("Hello, world")
	console.addNewline()
	console.incIndent()
		console.addWord("a")
		console.addWord("b")
		console.addNewline()
	console.decIndent()
	console.addWord("c")
	console.addNewline()
	console.flush()
	
	return true
}
