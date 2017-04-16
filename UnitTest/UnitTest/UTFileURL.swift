/**
 * @file	UTFileURL.swift
 * @brief	Unit test for URL class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTURLTest() -> Bool
{
	relativePathTest(relativePath: "/Users/someone/Documents/BattleFieldCode/script/a.js",
	                 base: "/Users/someone/Documents/BattleFieldCode/team")
	return true
}

public func relativePathTest(relativePath src: String, base: String)
{
	let srcurl  = URL(fileURLWithPath: src)
	let baseurl = URL(fileURLWithPath: base)
	let relurl  = URL.relativePath(sourceURL: srcurl, baseDirectory: baseurl)
	print("srcurl=\(srcurl.path), baseurl=\(baseurl.path) => relurl = \(relurl.relativePath)")
}
