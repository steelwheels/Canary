/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation

open class CNConsole
{
	public func print(string src: String){
		flush(string: src)
	}

	open func flush(string str: String){
		Swift.print(str, terminator: "")
	}
}

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

public class CNConnectedConsole: CNConsole
{
	private var mOutputPort: CNOutputPort<String>

	public init(outputPort port: CNOutputPort<String>){
		mOutputPort = port
	}
	/* Do not call this method from the outside */
	public override func flush(string str: String){
		mOutputPort.output(data: str)
	}
}
