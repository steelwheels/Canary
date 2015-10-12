/**
 * @file   CNTextSection.h
 * @brief  Define CNTextSection class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextSection : CNTextElement
{
	public var title    : String
	public var elements : Array<CNTextElement>

	public override init(){
		title = ""
		elements = []
		super.init()
	}
	
	public init(elements elms : Array<CNTextElement>){
		title = ""
		elements = elms
		super.init()
	}
	
	public init(title ttl : String, elements elms : Array<CNTextElement>){
		title = ttl
		elements = elms
		super.init()
	}
	
	public override func accept(visitor : CNTextVisitor, param: CNTextVisitorParam){
		visitor.visitSection(self, param: param)
	}
}