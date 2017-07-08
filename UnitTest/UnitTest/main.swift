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

print("*** UTGraphTest")
let result2 = UTGraphTest()

print("*** UTStackTest")
let result3 = UTStackTest()

print("*** UTNumber")
let result4 = UTNumber()

print("*** UTValue")
let result5 = UTValueTest()

console.print(string: "*** UTValueTable\n")
let result6 = UTValueTableTest(console: console)

print("*** UTURLTest")
let result7 = UTURLTest()

print("*** UTStateTest")
let result8 = UTStateTest() && UTTristateTest()

print("*** UTText")
let result9 = UTText()

print("*** UTConsoleTest")
let result10 = UTConsoleTest()

print("*** UTMath")
let result11 = UTMathTest()

print("*** UTToken")
let result12 = UTTokenTest()

print("*** UTObjectNotation")
let result13 = UTObjectNotation()

print("*** UTObjectCoder")
let result14 = UTObjectCoder()

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 &&
	     result10 && result11 && result12 && result13 && result14
if result {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
