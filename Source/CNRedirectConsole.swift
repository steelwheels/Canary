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
		for console in mConsoles {
			console.print(string: str)
		}
	}
}

