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
	let dumper  = CNTextDumper()
	let str0  = CNTextString(string: "Hello, ")
	//let str1  = CNTextString(string: "World")
	//let line0 = CNTextLine(strings: [str0, str1])
	//let sec0  = CNTextSection(title: "title", elements: [line0, line0])
	//dump(console, text: sec0)
	//dump(console, text: str0)
	dumper.dumpToConsole(console, text: str0)
	return true ;
}
