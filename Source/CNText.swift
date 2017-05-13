/**
 * @file	CNText.h
 * @brief	Define CNText class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNText
{
	public var dummy: Int

	public init(){
		dummy = 1
	}

	public func print()
	{
		print(indent: 0)
	}

	open func print(indent idt: Int){
	}

	public func printIndent(indent idt: Int){
		for _ in 0..<idt {
			Swift.print("  ", terminator:"")
		}
	}
}

public class CNTextLine: CNText
{
	private var mString: String

	public init(string str: String){
		mString = str
	}

	public var string: String {
		get { return mString }
	}

	public func append(string src: String){
		mString += src
	}

	open override func print(indent idt: Int){
		printIndent(indent: idt)
		Swift.print(mString)
	}
}

public class CNTextSection: CNText
{
	public var header: String	= ""
	public var footer: String	= ""

	public var contents: Array<CNText> = []

	public func append(string str: String){
		let newline = CNTextLine(string: str)
		contents.append(newline)
	}

	open override func print(indent idt: Int){
		if header != "" { printIndent(indent: idt) ; Swift.print(header) }

		let nextidt = idt + 1
		for text in contents {
			text.print(indent: nextidt)
		}

		if footer != "" { printIndent(indent: idt) ; Swift.print(footer) }
	}
}
