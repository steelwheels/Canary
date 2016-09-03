//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2016/08/14.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

print("Hello, World!")

print("*** UTListTest")
let result0 = UTListTest()

print("*** UTNumber")
let result1 = UTNumber()

print("*** UTURLTest")
let result2 = UTURLTest()

print("*** UTStateTest")
let result3 = UTStateTest() && UTTristateTest()

print("*** UTConsoleTest")
let result4 = UTConsoleTest()

print("*** UTObjectVisitor")
let result5 = UTObjectVisitor()

let result = result0 && result1 && result2 && result3 && result4 && result5
if result {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
