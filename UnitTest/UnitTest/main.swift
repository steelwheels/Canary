//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2016/08/14.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation

print("Hello, World!")

print("*** UTListTest")
let result0 = UTListTest()

print("*** UTURLTest")
let result1 = UTURLTest()

print("*** UTStateTest")
let result2 = UTStateTest() && UTTristateTest()

print("*** UTConsoleTest")
let result3 = UTConsoleTest()

let result = result0 && result1 && result2 && result3
if result0 {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
