//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation

print("*** UnitTest for Canary Framework ***")

var result = true

func test(title : String, result : Bool)
{
	print("\(title) ... ")
	if result {
		print("OK")
	} else {
		print("NG")
	}
}

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

result = result && test("[Test:CNTextBuffer] ... ", flag: UTTextBuffer())

print("TEST RESULT ... ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}


