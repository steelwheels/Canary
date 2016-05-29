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

	public class ConsoleText {
		private var	mText : String = ""
	}
	
	public override init(){
		accessLock	= NSLock()
		super.init()
	}

	public func print(text src: CNConsoleText){
		accessLock.lock()
		flush(src)
		accessLock.unlock()
	}
	
	public func print(string src: String){
		let text = CNConsoleText(string: src)
		accessLock.lock()
		flush(text)
		accessLock.unlock()
	}

	/* Do not call this method from the outside */
	public func flush(text: CNConsoleText){
		fatalError("must be overriden")
	}
}