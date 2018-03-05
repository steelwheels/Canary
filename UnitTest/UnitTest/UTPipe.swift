/**
 * @file	UTPipe.swift
 * @brief	Unit test for CNPipe class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation
import Canary

public func UTPipeTest(console cons: CNConsole) -> Bool
{
	let pipe = CNPipe()
	pipe.inputFile.put(string: "Hello, world !!\n")
	pipe.inputFile.put(string: "Good morning.\n")
	pipe.inputFile.put(string: "Good evening.\n")
	pipe.inputFile.close()
	
	var outstr: String = ""
	var docont = true
	while docont {
		if let c = pipe.outputFile.getChar() {
			outstr.append(c)
		} else {
			docont = false
		}
	}
	console.print(string: "outstr = \(outstr)\n")
	return true
}

