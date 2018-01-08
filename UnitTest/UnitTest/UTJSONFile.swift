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
	let result0 = UTJSONFileFromURL(console: cons)
	let result1 = UTJSONFileFromFile(console: cons)
	return result0 && result1
}

private func UTJSONFileFromURL(console cons: CNConsole) -> Bool
{
	var result  = false
	let readurl = URL(fileURLWithPath: "../UnitTest/Sample/sample-0.json")
	let (info, err) = CNJSONFile.readFile(URL: readurl)
	if let info = info {
		cons.print(string: "JSON -> \(info)\n")
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

private func UTJSONFileFromFile(console cons: CNConsole) -> Bool
{
	let (file, err) = CNOpenFile(filePath: "../UnitTest/Sample/sample-0.json", accessType: .ReadAccess)
	var result = false
	if let file = file {
		if let data = file.getAll() {
			let (jdata, err) = CNJSONFile.unserialize(string: data)
			if let info = jdata {
				cons.print(string: "JSON -> \(info)\n")
				let writeurl = URL(fileURLWithPath: "./sample-0-mod2.json")
				let _ = CNJSONFile.writeFile(URL: writeurl, dictionary: info)
				result = true
			} else {
				let errstr = err!.toString()
				cons.error(string: "[Error] \(errstr)\n")
			}
		} else {
			cons.error(string: "[Error] Failed to read data\n")
		}
	} else {
		let errstr = err!.toString()
		cons.error(string: "[Error] \(errstr)\n")
	}
	return result
}

