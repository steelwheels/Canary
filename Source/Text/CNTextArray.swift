/**
 * @file   CNTextArray.h
 * @brief  Define CNTextArray class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextArray : CNTextElement
{
	public var header = "["
	public var footer = "]"
	
	public var elements   : Array<CNTextElement>
	
	public override init(){
		elements = []
		super.init()
	}
	
	public init(array arr : Array<CNTextElement>){
		elements = arr
		super.init()
	}
	
	public override func accept(visitor : CNTextVisitor, param: CNTextVisitorParam){
		visitor.visitArray(self, param: param)
	}
}

