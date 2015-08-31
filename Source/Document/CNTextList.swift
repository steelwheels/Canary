/**
 * @file		CNTextList.h
 * @brief	Define CNTextList class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public enum CNTextListFormat {
	case AnsiCStyleList
}

public class CNTextList : CNDocumentObject
{
	public var contents : Array<CNDocumentObject>		= []
	
	public func addListItem(line : CNDocumentObject){
		contents.append(line)
	}
}

