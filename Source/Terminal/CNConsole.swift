/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNConsoleLine : NSObject {
	public var indent      : UInt
	public var lineString  : String
	
	public init(indent idt : UInt, line: String){
		indent     = idt
		lineString = line
		super.init()
	}
}

public class CNConsole : NSObject
{
	private var currentIndent : UInt = 0
	private var currentLine   : String = ""
	private var lines	  : Array<CNConsoleLine> = []
	
	public override init(){
		currentIndent = 0
		currentLine = ""
		lines = []
		super.init()
	}
	
	public func addWord(word : String){
		currentLine += word
	}
	
	public func addNewline(){
		flushCurrentLine()
	}
	
	public func flush(){
		flushCurrentLine()
		printLines(lines)
		lines = []
	}
	
	public func printLines(lines : Array<CNConsoleLine>){
		fatalError("Must be overridden")
	}
	
	public func incIndent(){
		flushCurrentLine()
		currentIndent += 1
	}
	
	public func decIndent(){
		flushCurrentLine()
		if currentIndent > 0 {
			currentIndent -= 1
		}
		
	}
	
	private func flushCurrentLine() {
		if currentLine.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
			let line = CNConsoleLine(indent: currentIndent, line: currentLine)
			lines.append(line)
			currentLine = ""
		}
	}
	
	public class func lineToString(line : CNConsoleLine) -> String {
		var result : String = ""
		for var i : UInt = 0 ; i<line.indent ; i++ {
			result += " "
		}
		result += line.lineString
		return result
	}
}