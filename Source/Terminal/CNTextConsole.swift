/**
 * @file	CNTextConsole.h
 * @brief	Define CNCTextConsole class
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
	public override func flushLine(line : String, attribute: Dictionary<String, AnyObject>? = nil){
		print(line)
	}
}

