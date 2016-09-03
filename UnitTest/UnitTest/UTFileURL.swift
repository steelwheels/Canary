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
