/**
 * @file	main.swift
 * @brief	Main function for unit tests
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

print("Hello, World!")

let console = CNFileConsole(file: CNTextFile.stdout)

print("*** UTCharacter")
let result0 = UTCharacter()

print("*** UTListTest")
let result1 = UTListTest()

print("*** UTStackTest")
let result2 = UTStackTest()

print("*** UTNumber")
let result3 = UTNumber()

print("*** UTValue")
let result4 = UTValueTest()

console.print(string: "*** UTValueTable\n")
let result5 = UTValueTableTest(console: console)

print("*** UTURLTest")
let result6 = UTURLTest()

print("*** UTStateTest")
let result7 = UTStateTest() && UTTristateTest()

print("*** UTText")
let result8 = UTText()

print("*** UTConsoleTest")
let result9 = UTConsoleTest()

print("*** UTMath")
let result10 = UTMathTest()

print("*** UTToken")
let result11 = UTTokenTest()

print("*** UTObjectNotation")
let result12 = UTObjectNotation()

print("*** UTObjectCoder")
let result13 = UTObjectCoder()

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 &&
	     result10 && result11 && result12 && result13
if result {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
