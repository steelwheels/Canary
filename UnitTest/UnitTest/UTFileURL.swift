/**
 * @file	UTFileURL.swift
 * @brief	Unit test for URL class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTURLTest(console cons: CNConsole) -> Bool
{
	relativePathTest(relativePath: "/Users/someone/Documents/BattleFieldCode/script/a.js",
	                 base: "/Users/someone/Documents/BattleFieldCode/team",
	                 console: cons)
	return true
}

public func relativePathTest(relativePath src: String, base: String, console cons: CNConsole)
{
	let srcurl  = URL(fileURLWithPath: src)
	let baseurl = URL(fileURLWithPath: base)
	let relurl  = URL.relativePath(sourceURL: srcurl, baseDirectory: baseurl)
	cons.print(string: "srcurl=\(srcurl.path), baseurl=\(baseurl.path) => relurl = \(relurl.relativePath)\n")
}
