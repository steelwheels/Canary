//
//  UTFileURL.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/02/05.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTURLTest() -> Bool
{
	relativePathTest("/Users/someone/Documents/BattleFieldCode/script/a.js",
	                 base: "/Users/someone/Documents/BattleFieldCode/team")
	return true
}

public func relativePathTest(src: String, base: String)
{
	let srcurl  = NSURL(fileURLWithPath: src)
	let baseurl = NSURL(fileURLWithPath: base)
	let relurl  = NSURL.relativePath(sourceURL: srcurl, baseDirectory: baseurl)
	print("srcurl=\(srcurl.path), baseurl=\(baseurl.path) => relurl = \(relurl.relativePath)")
}
