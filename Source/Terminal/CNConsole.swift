/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNConsole : NSObject
{
	private let accessLock	  : NSLock ;
	
	public override init(){
		accessLock	= NSLock()
		super.init()
	}
	
	public func printLine(line: String){
		accessLock.lock()
			flushLine(line)
		accessLock.unlock()
	}
	
	public func printLines(lines: Array<String>){
		accessLock.lock()
		for line in lines {
			flushLine(line)
		}
		accessLock.unlock()
	}
	
	public func printBuffer(buffer : CNTextBuffer){
		accessLock.lock()
		  buffer.dump({ (str : String) -> () in
			self.flushLine(str)
		  })
		accessLock.unlock()
	}

	/* Do not call this method from the outside */
	public func flushLine(line : String){
		fatalError("must be overriden")
	}
}