/**
 * @file   CNTextLine.h
 * @brief  Define CNTextLine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextLine : CNTextElement
{
	public var strings : Array<CNTextString>
	
	public override init(){
		strings = []
		super.init()
	}
	
	public init(strings array : Array<CNTextString>){
		strings = array
		super.init()
	}
	
	public override func accept(visitor : CNTextVisitor){
		visitor.visitLine(self)
	}
}
