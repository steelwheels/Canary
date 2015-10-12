/**
 * @file	CNTextConsole.h
 * @brief	Define CNCTextonsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextConsole : CNConsole
{
	private let lock : NSLock ;
	
	public override init(){
		lock = NSLock()
		super.init()
	}
	
	public override func printLines(lines : Array<CNConsoleLine>){
		lock.lock() ;
		for line in lines {
			let str = CNConsole.lineToString(line)
			print(str)
		}
		lock.unlock()
	}
}

