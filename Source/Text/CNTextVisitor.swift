/**
 * @file   CNTextVisitor.h
 * @brief  Define CNTextVisitor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextVisitorParam : NSObject {
	
}

public class CNTextVisitor : NSObject
{
	public func visitSection(section : CNTextSection, param: CNTextVisitorParam){
	}
	
	public func visitDictionary(dictionary : CNTextDictionary, param: CNTextVisitorParam){
	}
	
	public func visitLine(line : CNTextLine, param: CNTextVisitorParam){
	}
	
	public func visitString(string : CNTextString, param: CNTextVisitorParam){
	}
}
