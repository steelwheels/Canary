/**
* @file		UTTextBuffer.h
* @brief	Unit test for CNTextBuffer class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation

public func UTTextBuffer() -> Bool
{
	let textbuffer = CNTextBuffer()
	print("*** Initial state: ") ;
	textbuffer.dump()
	
	print("*** appendString:")
	textbuffer.append("1st statement")
	textbuffer.dump()
	
	print("*** Indent")
	textbuffer.incrementIndent()
	textbuffer.append("indented text")
	textbuffer.decrementIndent()
	textbuffer.append("2nd statement")
	textbuffer.dump()
	
	return true ;
}
