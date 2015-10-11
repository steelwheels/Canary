/**
 * @file   CNTextString.h
 * @brief  Define CNTextString class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextString : CNTextElement
{
	public var string : String
	
	public override init(){
		string = ""
		super.init()
	}
	
	public init(string str : String){
		string = str
		super.init()
	}
	
	public override func accept(visitor : CNTextVisitor){
		visitor.visitString(self)
	}
}
