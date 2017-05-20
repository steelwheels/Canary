/**
 * @file	main.swift
 * @brief	Main function for unit tests
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

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

print("*** UTText")
let result6 = UTText()

print("*** UTConsoleTest")
let result7 = UTConsoleTest()

print("*** UTObjectVisitor")
let result8 = UTObjectVisitor()

print("*** UTMath")
let result9 = UTMathTest()

print("*** UTToken")
let result10 = UTTokenTest()

print("*** UTObjectNotation")
let result11 = UTObjectNotation()

print("*** UTObjectCoder")
let result12 = UTObjectCoder()

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 &&
	     result10 && result11 && result12
if result {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
