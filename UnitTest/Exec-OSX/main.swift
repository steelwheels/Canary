//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation

func test(title: String, flag : Bool) -> Bool
{
	print("\(title)", terminator:"")
	if flag {
		print("OK")
	} else {
		print("NG")
	}
	return flag
}

print("*** UnitTest for Canary Framework ***")

var result = true
result = test("[Test:CNTextBuffer]    ... ", flag: UTTextBuffer()) && result
result = test("[Test:CNTextConsole] ... ", flag: UTTextConsole()) && result
result = test("[Test:NSURL extension] ... ", flag: UTURL()) && result
print("TEST RESULT ... ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}


