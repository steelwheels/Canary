/**
* @file	UTFileManager.swift
* @brief	Unit test for CNFileManager class
* @par Copyright
*   Copyright (C) 2018 Steel Wheels Project
*/

import Canary
import Foundation

public func UTFileManagerTest(console cons: CNConsole) -> Bool
{
	let result0 = UTCheckFileType(pathString: "Info.plist", fileType: .File, console: cons) ;
	let result1 = UTCheckFileType(pathString: "../OSX", fileType: .Directory, console: cons) ;
	let result2 = UTCheckFileType(pathString: "hoge.hoge", fileType: .NotExist, console: cons) ;
	return result0 && result1 && result2
}

private func UTCheckFileType(pathString path: String, fileType type: CNFileType, console cons: CNConsole) -> Bool
{
	let fmanager = FileManager.default
	let result = fmanager.checkFileType(pathString: path)
	cons.print(string: "path:\(path) -> type:\(result.description)\n")
	return result == type
}

