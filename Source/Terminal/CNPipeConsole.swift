/**
* @file		CNPipeConsole.h
* @brief	Define CNCPipeConsole class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation

public class CNPipeConsole : CNConsole
{
	var mTargetConsole : CNConsole? = nil

	public init(target : CNConsole){
		mTargetConsole = target
	}

	public var targetConsole : CNConsole? {
		get		{ return mTargetConsole }
		set(newconsole)	{ mTargetConsole = newconsole }
	}

	public override func flushLine(line : String, attribute: Dictionary<String, AnyObject>?){
		if let target = mTargetConsole {
			target.flushLine(line, attribute: attribute)
		}
	}
}

