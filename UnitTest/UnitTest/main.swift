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

print("*** UTCharacter")
let result0 = UTCharacter()

print("*** UTListTest")
let result1 = UTListTest()

print("*** UTNumber")
let result2 = UTNumber()

print("*** UTValue")
let result3 = UTValueTest()

print("*** UTURLTest")
let result4 = UTURLTest()

print("*** UTStateTest")
let result5 = UTStateTest() && UTTristateTest()

print("*** UTConsoleTest")
let result6 = UTConsoleTest()

print("*** UTObjectVisitor")
let result7 = UTObjectVisitor()

print("*** UTMath")
let result8 = UTMathTest()

print("*** UTToken")
let result9 = UTTokenTest()

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9
if result {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
