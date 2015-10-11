/**
 * @file   CNTextElement.h
 * @brief  Define CNTextElement class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextElement : NSObject
{
	public func accept(visitor : CNTextVisitor){
		fatalError("This method must be overridden")
	}
}

