/**
 * @file	UTFile.swift
 * @brief	Unit test for CNFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTFileTest(console cons: CNConsole) -> Bool
{
	let (file0, err0) = CNOpenFile(filePath: "UTFile.txt", accessType: .WriteAccess)
	if let e = err0 {
		console.error(string: "[Error] \(e.toString())\n")
		return false
	}
	if let f = file0 {
		f.put(string: "Hello, world!\nGood morning\n")
		f.close()
	} else {
		console.error(string: "[Error] Internal error 0\n")
		return false
	}
	let (file1, err1) = CNOpenFile(filePath: "UTFile.txt", accessType: .ReadAccess)
	if let e = err1 {
		console.error(string: "[Error] \(e.toString())\n")
		return false
	}
	if let f = file1 {
		f.put(string: "Hello, world!\nGood morning\n")
		var no = 1
		while let line = f.getLine() {
			console.print(string: "\(no): \(line)")
			no += 1
		}
		f.close()
	} else {
		console.error(string: "[Error] Internal error 1\n")
		return false
	}

	return true
}

