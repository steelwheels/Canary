/**
 * @file	UTJSONFile.swift
 * @brief	Unit test for CNJSONFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTJSONFile(console cons: CNConsole) -> Bool
{
	var result = false

	let readurl = URL(fileURLWithPath: "../UnitTest/Sample/sample-0.json")
	let (info, err) = CNJSONFile.readFile(URL: readurl)
	if let info = info {
		cons.print(string: "JSON -> \(info)")
		let writeurl = URL(fileURLWithPath: "./sample-0-mod.json")
		let _ = CNJSONFile.writeFile(URL: writeurl, dictionary: info)
		result = true
	} else {
		let desc: String
		if let e = err {
			desc = e.toString()
		} else {
			desc = "Unknown error"
		}
		cons.error(string: "Can not read file: \(desc)")
	}
	return result
}

