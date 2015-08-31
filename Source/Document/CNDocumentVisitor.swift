/**
 * @file	CNDocumentVisitor.h
 * @brief	Define CNDocumentVisitor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNDocumentVisitorInfo : NSObject
{
	
}

public class CNDocumentVisitor : NSObject
{
	public func accept(obj: CNDocumentObject, info: CNDocumentVisitorInfo){
		if let document = obj as? CNDocument {
			visitDocument(document, info: info)
		} else if let section = obj as? CNSection {
			visitSection(section, info: info)
		} else if let line = obj as? CNTextLine {
			visitTextLine(line, info: info)
		} else if let list = obj as? CNTextList {
			visitTextList(list, info: info)
		} else {
			fatalError("Unknown document element")
		}
	}
	
	public func visitDocument(document : CNDocument, info: CNDocumentVisitorInfo){
	}
	
	public func visitSection(section : CNSection, info: CNDocumentVisitorInfo){
	}
	
	public func visitTextLine(textline : CNTextLine, info: CNDocumentVisitorInfo){
	}
	
	public func visitTextList(textlist : CNTextList, info: CNDocumentVisitorInfo){
	}
}
