//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation

func test(flag : Bool) -> Bool
{
	if flag {
		print("Result: OK")
	} else {
		print("Result: NG")
	}
	return flag
}

print("*** UnitTest for Canary Framework ***")

var result = true

print("[Test:CNTypeName]")
result = test(UTClassUtil()) && result

print("[Test:CNNumberExtension]")
result = test(UTNumber()) && result

print("[Test:CNTextConsole]")
result = test(UTTextConsole()) && result

print("[Test:CNTextDumper]")
result = test(UTTextDumper()) && result

print("[Test:NSURL extension]")
result = test(UTURL()) && result

print("[Test:CNJSONFile]")
result = test(UTJSONFile()) && result

print("[Test:CNObjectSerializer]")
result = test(UTObjectSerializer()) && result

print("[Test:CNGraphicsSerializer]")
result = test(UTGraphicsSerializer()) && result

print("TEST RESULT ... ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}


