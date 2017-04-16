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

print("*** UTConsoleTest")
let result6 = UTConsoleTest()

print("*** UTObjectVisitor")
let result7 = UTObjectVisitor()

print("*** UTMath")
let result8 = UTMathTest()

print("*** UTToken")
let result9 = UTTokenTest()

print("*** UTObjectNotation")
let result10 = UTObjectNotation()

print("*** UTObjectCoder")
let result11 = UTObjectCoder()

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 &&
	     result10 && result11
if result {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
