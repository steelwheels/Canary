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
		fatalError("Must be override")
	}

	public func printIndent(indent idt: Int){
		for _ in 0..<idt {
			Swift.print("  ", terminator:"")
		}
	}

	open func append(string src: String){
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

	public override func append(string src: String){
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

	private var mContents: Array<CNText> = []

	public func add(text txt: CNText){
		mContents.append(txt)
	}

	public func add(string str: String){
		let newline = CNTextLine(string: str)
		mContents.append(newline)
	}

	public func add(strings strs: Array<String>){
		for s in strs {
			add(string: s)
		}
	}

	public func addMultiLines(string str: String) {
		let stmts = str.components(separatedBy: "\n")
		add(strings: stmts)

	}

	public override func append(string str: String){
		let count = mContents.count
		if count > 0 {
			mContents[count-1].append(string: str)
		} else {
			add(string: str)
		}
	}

	open override func print(indent idt: Int){
		if header != "" { printIndent(indent: idt) ; Swift.print(header) }

		let nextidt = idt + 1
		for text in mContents {
			text.print(indent: nextidt)
		}

		if footer != "" { printIndent(indent: idt) ; Swift.print(footer) }
	}
}

public func CNAddStringToText(text txt:CNText, string str: String) -> CNTextSection
{
	if let line = txt as? CNTextLine {
		let section = CNTextSection()
		section.add(text: line)
		section.add(string: str)
		return section
	} else if let section = txt as? CNTextSection {
		section.add(string: str)
		return section
	} else {
		fatalError("Unknown object")
	}
}

public func CNAddStringsToText(text txt:CNText, strings strs: Array<String>) -> CNText
{
	let count = strs.count
	if count > 0 {
		let section = CNAddStringToText(text: txt, string: strs[0])
		let rests   = strs[1..<count]
		for str in rests {
			section.add(string: str)
		}
		return section
	} else {
		return txt
	}
}



