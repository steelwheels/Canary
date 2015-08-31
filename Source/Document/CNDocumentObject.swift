/**
 * @file	CNDocumentObject.h
 * @brief	Define CNDocumentObject class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNDocumentObject : NSObject
{
	public var parentText : CNDocumentObject?	= nil
	
	public init(parent : CNDocumentObject){
		parentText = parent
		super.init()
	}
	
	public override init(){
		super.init()
	}
}
