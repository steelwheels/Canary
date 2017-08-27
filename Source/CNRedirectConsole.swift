/**
 * @file	CNRedirectConsole.h
 * @brief	Define CNRedirectConsole class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNRedirectConsole : CNConsole
{
	private var mConsoles: Array<CNConsole> = []
	
	public override init(){
		super.init()
	}

	public func addOutput(console: CNConsole){
		mConsoles.append(console)
	}
	
	public func removeAllOutputs(){
		mConsoles.removeAll()
	}
	
	public override func print(string str: String){
		if mConsoles.count > 0 {
			for console in mConsoles {
				console.print(string: str)
			}
		} else {
			NSLog("[CNRedirectConsole] \(str)")
		}
	}

	public func print(consoleId cid: Int, string str: String){
		if cid < mConsoles.count {
			mConsoles[cid].print(string: str)
		} else {
			NSLog("[CNRedirectConsole:\(cid)] \(str)")
		}
	}
}

