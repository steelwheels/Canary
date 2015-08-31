/**
 * @file	CNTextLine.h
 * @brief	Define CNTextLine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextLine : CNDocumentObject
{
	public var content : String = ""
	
	public init(string : String){
		content = string
		super.init()
	}
	
	public override init(){
		super.init()
	}
}
