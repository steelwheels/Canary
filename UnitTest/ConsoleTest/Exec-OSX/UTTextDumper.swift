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
	
	let dumper  = CNTextDumper()
	let str0  = CNTextString(string: "Hello, ")
	let str1  = CNTextString(string: "World")
	let line0 = CNTextLine(strings: [str0, str1])
	let dict0 = CNTextDictionary(dictionary: ["item0":str0, "item1":str1])
	let arr0  = CNTextArray(array: [CNTextString(string: "elm0"), CNTextString(string: "elm1")])
	let sec0  = CNTextSection(title: "title", elements: [line0, line0, dict0, arr0])
	let buffer = dumper.dumpToBuffer(sec0)
	
	let console = CNTextConsole()
	console.printBuffer(buffer)

	return true ;
}
