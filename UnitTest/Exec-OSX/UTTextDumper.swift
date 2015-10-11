/**
 * @file		UTTextBuffer.h
 * @brief	Unit test for CNTextBuffer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Canary

public func UTTextDumper() -> Bool
{
	let console = CNTextConsole()
	
	print("** output0")
	let str0 = CNTextString(string: "Hello, ")
	dump(console, text: str0)
	
	print("** output1")
	let str1  = CNTextString(string: "World")
	let line0 = CNTextLine(strings: [str0, str1])
	dump(console, text: line0)
	
	print("** output2")
	let sec0  = CNTextSection(title: "title", elements: [line0, line0])
	dump(console, text: sec0)
	
	return true ;
}

private func dump(console : CNTextConsole, text : CNTextElement)
{
	let dumper = CNTextDumper(console: console)
	dumper.dumpToConsole(text)
	print("** end of output")
}
