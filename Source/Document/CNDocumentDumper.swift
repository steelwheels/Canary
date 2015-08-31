/**
 * @file	CNDocumentDumper.h
 * @brief	Define CNDocumentToString class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNDocumentDumper : CNDocumentVisitor
{
	var documentFormat : CNDocumentFormat
	var decodedStrings : Array<String> = []
	var currentIndent  : UInt = 0
	
	public init(format : CNDocumentFormat){
		documentFormat = format
		super.init()
	}
	
	public func dumpToString(document : CNDocument) -> String {
		let info = CNDocumentVisitorInfo()
		accept(document, info: info)
		
		var result = ""
		for string in decodedStrings {
			result += string + "\n"
		}
		return result
	}
	
	public override func visitDocument(document : CNDocument, info: CNDocumentVisitorInfo){
		for section in document.contents {
			accept(section, info:info)
		}
	}
	
	public override func visitSection(section : CNSection, info: CNDocumentVisitorInfo){
		let header = section.headerText.content
		if header.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
			appendNewString(header)
		}
		currentIndent++
		
		for child in section.contents {
			accept(child, info:info)
		}
		
		currentIndent--
		let footer = section.footerText.content
		if footer.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
			appendNewString(footer)
		}
	}
	
	public override func visitTextLine(textline : CNTextLine, info: CNDocumentVisitorInfo){
		appendNewString(textline.content)
	}
	
	public override func visitTextList(textlist : CNTextList, info: CNDocumentVisitorInfo){
		let hascomma = documentFormat.hasCommaAfterTextListItem()
		for child in textlist.contents {
			accept(child, info:info)
			if hascomma {
				appendStringToCurrentLine(",")
			}
		}
	}
	
	private func indentString() -> String {
		var result = ""
		for var i=UInt(0); i<currentIndent ; i++ {
			result += "  "
		}
		return result ;
	}
	
	private func appendNewString(src : String){
		decodedStrings.append(indentString() + src)
	}
	
	private func appendStringToCurrentLine(src : String){
		if decodedStrings.count > 0 {
			let index = decodedStrings.count - 1
			decodedStrings[index] += src
		} else {
			decodedStrings.append(src)
		}
	}
	
}