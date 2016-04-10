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
	
	public override func print(text src: CNConsoleText){
		for console in mConsoles {
			console.print(text: src)
		}
	}
	
	public override func print(string src: String){
		let text = CNConsoleText(string: src)
		for console in mConsoles {
			console.print(text: text)
		}
	}
	
	/* Do not call this method from the outside */
	public override func flush(text: CNConsoleText){
		for console in mConsoles {
			console.flush(text)
		}
	}
}

