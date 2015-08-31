/**
 * @file	CNDocumentFormat.h
 * @brief	Define CNDocumentFormat class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public enum CNDocumentFormatType {
	case ObjectNotation
}

public class CNDocumentFormat : NSObject
{
	var formatType : CNDocumentFormatType
	
	public init(type : CNDocumentFormatType){
		formatType = type
		super.init()
	}
	
	public func hasCommaAfterTextListItem() -> Bool {
		var result = false
		switch formatType {
		case .ObjectNotation: result = true
		}
		return result
	}
}
