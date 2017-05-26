/**
 * @file	CNFileConsole.h
 * @brief	Define CNFileConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNFileConsole : CNConsole
{
	private var mTextFile	: CNTextFile
	
	public init(file f: CNTextFile){
		mTextFile = f
		super.init()
	}

	/* Do not call this method from the outside */
	public override func flush(string str: String){
		mTextFile.print(string: str)
	}
}

