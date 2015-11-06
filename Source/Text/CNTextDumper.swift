/**
 * @file   CNTextDumper.h
 * @brief  Define CNTextDumper class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

internal class CNTextDumperParam : CNTextVisitorParam {
	internal var textBuffer : CNTextBuffer
	
	internal init(buffer : CNTextBuffer){
		textBuffer = buffer
		super.init()
	}
}

public class CNTextDumper : CNTextVisitor
{
	private var textBuffer    : CNTextBuffer = CNTextBuffer()
	private var indentSpace	  : String	 = ""
	
	public func dumpToBuffer(text : CNTextElement) -> CNTextBuffer {
		let buffer = CNTextBuffer()
		let param  = CNTextDumperParam(buffer: buffer)
		text.accept(self, param: param)
		return buffer
	}

	public override func visitSection(section : CNTextSection, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let buffer  = dparam.textBuffer
		
		/* Put title */
		let title = section.title
		let titlelen = title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		if titlelen > 0 {
			buffer.addString(title)
			buffer.addNewline()
			buffer.incrementIndent()
		}
		
		/* Put contentents */
		for element in section.elements {
			element.accept(self, param: param)
		}
		
		/* End of section */
		if titlelen > 0 {
			buffer.decrementIndent()
		}
	}
	
	public override func visitDictionary(dictionary : CNTextDictionary, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let buffer  = dparam.textBuffer
		
		var is1st = true
		buffer.addString("[")
		for (key, value) in dictionary.elements {
			if is1st {
				is1st = false
			} else {
				buffer.addString(", ")
			}
			buffer.addString("\(key):")
			value.accept(self, param: param)
		}
		buffer.addString("]")
		buffer.addNewline()
	}
	
	public override func visitArray(array : CNTextArray, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let buffer  = dparam.textBuffer
		
		buffer.addString("[")
		var is1st = true
		for value in array.elements {
			if is1st {
				is1st = false
			} else {
				buffer.addString(", ")
			}
			value.accept(self, param: param)
		}
		buffer.addString("]")
		buffer.addNewline()
	}

	public override func visitLine(line : CNTextLine, param: CNTextVisitorParam){
		for value in line.strings {
			value.accept(self, param: param)
		}
		let dparam  = param as! CNTextDumperParam
		let buffer  = dparam.textBuffer
		buffer.addNewline()
	}
	
	public override func visitString(str : CNTextString, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let buffer  = dparam.textBuffer
		buffer.addString(str.string)
	}
}
