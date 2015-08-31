/**
* @file		UTDocument.h
* @brief	Define UTDocument class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import AppKit
import Canary

public func UTDocument() -> Bool
{
	let doc = CNDocument()
	let format = CNDocumentFormat(type: CNDocumentFormatType.ObjectNotation)
	
	println("[Empty document]") ;
	dumpDocument(doc, format)
	
	println("[Add section]") ;
	let sec0 = CNSection()
	sec0.headerText = CNTextLine(string: "+section header+")
	sec0.footerText = CNTextLine(string: "+section footer+")
	doc.contents.append(sec0)
	dumpDocument(doc, format)
	
	println("[Add section 2]")
	let sec1 = CNSection()
	sec0.contents.append(sec1)
	sec1.contents.append(CNTextLine(string: "main statement"))
	dumpDocument(doc, format)
	
	println("[Add list]")
	let list0 = CNTextList()
	list0.contents.append(CNTextLine(string: "item0"))
	list0.contents.append(CNTextLine(string: "item1"))
	list0.contents.append(CNTextLine(string: "item2"))
	sec0.contents.append(list0)
	dumpDocument(doc, format)
	
	return true ;
}

public func dumpDocument(doc : CNDocument, format: CNDocumentFormat)
{
	let dumper = CNDocumentDumper(format: format)
	let result = dumper.dumpToString(doc)
	println("\"\(result)\"")
}