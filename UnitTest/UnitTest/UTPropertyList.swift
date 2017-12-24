/**
 * @file	UTPropertyList.swift
 * @brief	Unit test for CNProprtyList class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */
import Canary
import Foundation

public func UTPropertyListTest(console cons: CNConsole) -> Bool
{
	var result: Bool = true	// No error

	let proplist = CNPropertyList(bundleDirectoryName: "UnitTest.bundle")
	var version: String = "<Unknown>"
	if let v  = proplist.version {
		version = v
	} else {
		result = false
	}
	console.print(string: "Version in property list: \(version)\n")

	return result
}

