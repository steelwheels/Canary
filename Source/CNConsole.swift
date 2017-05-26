/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation

open class CNConsole
{
	public let accessLock	  : NSLock ;
	
	public init(){
		accessLock	= NSLock()
	}
	
	public func print(string src: String){
		flush(string: src)
	}

	/* Do not call this method from the outside */
	open func flush(string str: String){
		fatalError("must be overriden")
	}
}
