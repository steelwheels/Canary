/**
 * @file	CNTextBuffer.h
 * @brief	Define CNTextBuffer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

internal class CNTextLine : NSObject
{
	var indent	: UInt		= 0
	var content	: String	= ""
	
	internal func dump(){
		for var i=UInt(0) ; i<indent ; i++ {
			print("\t", terminator: "")
		}
		print(content)
	}
}

public class CNTextBuffer : NSObject
{
	private var contents	  : Array<CNTextLine>	= []
	private var currentString : String		= ""
	private var currentIndent : UInt		= 0
	
	public func incrementIndent(){
		flushCurrentString()
		currentIndent += 1
	}
	
	public func decrementIndent(){
		flushCurrentString()
		if currentIndent > 0 {
			currentIndent -= 1
		}
	}
	
	public func append(str : String){
		currentString += str
	}
	
	public func newline(){
		let textline = CNTextLine()
		textline.indent  = currentIndent
		textline.content = currentString
		contents.append(textline)
		currentString = ""
	}
	
	public func dump(){
		flushCurrentString()
		for textline in contents {
			textline.dump()
		}
	}
	
	private func flushCurrentString(){
		let len = currentString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		if len > 0 {
			newline()
		}
	}
}
