/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation

open class CNConsole
{
	open func print(string src: String){
		Swift.print(src, terminator:"")
	}
}

public class CNFileConsole : CNConsole
{
	private var mTextFile	: CNTextFile

	public init(file f: CNTextFile){
		mTextFile = f
	}
	
	public override func print(string str: String){
		mTextFile.print(string: str)
	}
}

public class CNIndentConsole: CNConsole
{
	private var mConsole: 		CNConsole
	private var mIndentValue:  	Int
	private var mIndentString:	String

	public init(console cons: CNConsole){
		mConsole      = cons
		mIndentValue  = 0
		mIndentString = ""
	}

	public override func print(string src: String){
		mConsole.print(string: mIndentString + src)
	}

	public func incrementIndent(){
		mIndentValue  += 1
		mIndentString =  CNIndentConsole.indentString(indent: mIndentValue)
	}

	public func decrementIndent(){
		if mIndentValue > 0 {
			mIndentValue -= 1
			mIndentString =  CNIndentConsole.indentString(indent: mIndentValue)
		}
	}

	private class func indentString(indent idt: Int) -> String {
		var result: String = ""
		for _ in 0..<idt {
			result += " "
		}
		return result
	}
}

public class CNConnectedConsole: CNConsole
{
	private var mOutputPort: CNOutputPort<String>

	public init(outputPort port: CNOutputPort<String>){
		mOutputPort = port
	}
	public override func print(string str: String){
		mOutputPort.output(data: str)
	}
}
