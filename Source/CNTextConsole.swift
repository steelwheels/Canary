/**
 * @file	CNTextConsole.h
 * @brief	Define CNTextConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextConsole : CNConsole
{
	public override init(){
		super.init()
	}

	/* Do not call this method from the outside */
	public override func flush(text t: CNConsoleText){
		for word in t.words {
			Swift.print(word.string)
		}
	}
}

