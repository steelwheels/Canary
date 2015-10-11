/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNConsole : NSObject
{
	private var mIndent : UInt = 0
	public var  indentUnit = " "
	
	public func putString(str : String){
		fatalError("This method must be overridden")
	}
	
	public func putNewline(){
		fatalError("This method must be overridden")
	}
	
	public func currentIndent() -> UInt {
		return mIndent
	}
	
	public func incIndent(level : UInt = 1){
		mIndent += level ;
	}
	
	public func decIndent(level : UInt = 1){
		if(mIndent > level){
			mIndent -= level
		} else {
			mIndent = 0
		}
	}
	
	public func indentString() -> String {
		var result = ""
		for(var i=UInt(0) ; i<mIndent ; i++){
			result += indentUnit
		}
		return result
	}
}