/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation

open class CNConsole
{
	public init(){

	}
	
	open func print(string str: String){
		Swift.print(str, terminator: "")
	}

	open func error(string str: String){
		Swift.print(str, terminator: "")
	}

	open func scan() -> String? {
		let input = FileHandle.standardInput
		return String(data: input.availableData, encoding: .utf8)
	}
}

public class CNFileConsole : CNConsole
{
	var inputHandle:	FileHandle?	= nil
	var outputHandle:	FileHandle?	= nil
	var errorHandle:	FileHandle?	= nil

	public init(input ihdl: FileHandle?, output ohdl: FileHandle?, error ehdl: FileHandle?){
		inputHandle	= ihdl
		outputHandle	= ohdl
		errorHandle	= ehdl
	}

	public override init() {
		inputHandle	= FileHandle.standardInput
		outputHandle	= FileHandle.standardOutput
		errorHandle	= FileHandle.standardError
	}

	public override func print(string str: String){
		if let ohdl = outputHandle, let data = str.data(using: .utf8) {
			ohdl.write(data)
		}
	}

	public override func error(string str: String){
		if let ehdl = errorHandle, let data = str.data(using: .utf8) {
			ehdl.write(data)
		} else {
			print(string: str)
		}
	}

	public override func scan() -> String? {
		if let ihdl = inputHandle {
			return String(data: ihdl.availableData, encoding: .utf8)
		} else {
			return nil
		}
	}
}



