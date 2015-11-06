/**
 * @file   CNTextBuffer.h
 * @brief  Define CNTextDumper class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

internal class CNIndentedString
{
	internal var currentIndent : UInt
	internal var textLine	  : String
	
	internal init(indent : UInt, line : String){
		currentIndent	= indent
		textLine	= line
	}
	
	internal func addString(str : String){
		textLine += str
	}
	
	internal func normalize() -> String {
		var spaces : String = ""
		for(var i:UInt=0 ; i<currentIndent ; i++){
			spaces += "  "
		}
		return spaces + textLine
	}
}

public class CNTextBuffer
{
	private var textLines		: Array<CNIndentedString> = []
	private var currentLine		: CNIndentedString?	  = nil
	private var currentIndent	: UInt			  = 0
	
	public func addString(str : String){
		if let line = currentLine {
			line.addString(str)
		} else {
			currentLine = CNIndentedString(indent: currentIndent, line: str)
		}
	}
	
	public func addNewline(){
		if let line = currentLine {
			textLines.append(line)
			currentLine = nil
		}
	}
	
	public func incrementIndent(){
		currentIndent += 1
	}
	
	public func decrementIndent(){
		if currentIndent > 0 {
			currentIndent -= 1
		}
	}
	
	public func dump(dumpfunc : (String) -> ()){
		for line in textLines {
			let string = line.normalize()
			dumpfunc(string)
		}
		if let line = currentLine {
			let string = line.normalize()
			dumpfunc(string)
		}
	}
	
}