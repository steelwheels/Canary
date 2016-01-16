/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation

public class CNConsole : NSObject
{
	private let accessLock	  : NSLock ;

	public override init(){
		accessLock	= NSLock()
		super.init()
	}

	public func printLine(line: String, attribute: Dictionary<String, AnyObject>? = nil){
		accessLock.lock()
			flushLine(line, attribute: attribute)
		accessLock.unlock()
	}

	public func printLines(lines: Array<String>, attribute: Dictionary<String, AnyObject>? = nil){
		accessLock.lock()
		for line in lines {
			flushLine(line, attribute: attribute)
		}
		accessLock.unlock()
	}

	/* Do not call this method from the outside */
	public func flushLine(line : String, attribute: Dictionary<String, AnyObject>?){
		fatalError("must be overriden")
	}
}
