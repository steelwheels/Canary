/**
 * @file   CNTextDictionary.h
 * @brief  Define CNTextDictionary class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextDictionary : CNTextElement
{
	public var header = "["
	public var footer = "]"

	public var elements   : Dictionary<String, CNTextElement>
	
	public override init(){
		elements = [:]
		super.init()
	}
	
	public init(dictionary dict : Dictionary<String, CNTextElement>){
		elements = dict
		super.init()
	}
	
	public override func accept(visitor : CNTextVisitor, param: CNTextVisitorParam){
		visitor.visitDictionary(self, param: param)
	}
}
