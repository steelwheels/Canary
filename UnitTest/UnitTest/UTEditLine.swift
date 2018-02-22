/**
* @file	UTEditLine.swift
* @brief	Unit test for CNEditLine class
* @par Copyright
*   Copyright (C) 2018 Steel Wheels Project
*/

import Canary
import Foundation

public func UTEditLine(console cons: CNConsole) -> Bool
{
	let editline = CNEditLine()
	editline.setup(programName: "UnitTest") ;
	if let str = editline.gets() {
		console.print(string: "input: \(str)\n")
	}
	editline.finalize()
	return true
}

