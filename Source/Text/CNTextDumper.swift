/**
 * @file   CNTextDumper.h
 * @brief  Define CNTextDumper class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextDumper : CNTextVisitor
{
	var mConsole : CNConsole
	
	public init(console : CNConsole){
		mConsole = console
		super.init()
	}
	
	public func dumpToConsole(text: CNTextElement){
		text.accept(self)
	}
	
	public override func visitSection(section : CNTextSection){
		/* Put string */
		let title = section.title
		if(title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
			mConsole.putString(title)
			mConsole.putNewline()
			mConsole.incIndent()
		}
		
		/* Put contentents */
		for element in section.elements {
			element.accept(self)
		}
		
		if(title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
			mConsole.decIndent()
		}
	}
	
	public override func visitLine(line : CNTextLine){
		for str in line.strings {
			str.accept(self)
		}
		mConsole.putNewline()
	}
	
	public override func visitString(str : CNTextString){
		mConsole.putString(str.string)
	}
}
