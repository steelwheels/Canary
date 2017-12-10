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

	var version: String
	if let v = CNPropertyList.version {
		version = v
	} else {
		version = "<Unknown>"
		result  = false
	}
	console.print(string: "Version in property list: \(version)\n")

	return result
}

