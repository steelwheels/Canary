/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNConsoleLine : NSObject {
	public var indent	: UInt
	public var words	: Array<String>
	
	public init(indent idt : UInt, words wds: Array<String>){
		indent	= idt
		words	= wds
		super.init()
	}
}

public class CNConsole : NSObject
{
	private var currentIndent : UInt = 0
	private var currentWords  : Array<String>
	private var lines	  : Array<CNConsoleLine>
	private var indentSpace	  : String
	
	public override init(){
		currentIndent	= 0
		currentWords	= []
		lines		= []
		indentSpace	= "  "
		super.init()
	}
	
	public func addWord(word : String){
		currentWords.append(word)
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
	
	public func printMultiLineString(str : String){
		let srclines = str.componentsSeparatedByString("\n")
		var dstlines : Array<CNConsoleLine> = []
		for srcline in srclines {
			let dstline = CNConsoleLine(indent: currentIndent, words: [srcline])
			dstlines.append(dstline)
		}
		printLines(dstlines)
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
	
	public func indentString(line : CNConsoleLine) -> String {
		var result : String = ""
		for var i : UInt = 0 ; i<line.indent ; i++ {
			result += indentSpace
		}
		return result
	}
	
	private func flushCurrentLine() {
		if currentWords.count > 0 {
			let newline = CNConsoleLine(indent: currentIndent, words: currentWords)
			lines.append(newline)
			currentWords = []
		}
	}
}