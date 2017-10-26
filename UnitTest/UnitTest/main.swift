/**
 * @file	main.swift
 * @brief	Main function for unit tests
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

let console = CNConsole()
console.print(string: "Hello, World!\n")

console.print(string: "*** UTCharacter\n")
let result0 = UTCharacter(console: console)

console.print(string: "*** UTListTest\n")
let result1 = UTListTest(console: console)

console.print(string: "*** UTGraphTest\n")
let result2 = UTGraphTest(console: console)

console.print(string: "*** UTStackTest\n")
let result3 = UTStackTest(console: console)

console.print(string: "*** UTNumber\n")
let result4 = UTNumber(console: console)

console.print(string: "*** UTValue\n")
let result5 = UTValueTest(console: console)

console.print(string: "*** UTValueTable\n")
let result6 = UTValueTableTest(console: console)

console.print(string: "*** UTURLTest\n")
let result7 = UTURLTest(console: console)

console.print(string: "*** UTStateTest\n")
let result8 = UTStateTest(console: console) && UTTristateTest(console: console)

console.print(string: "*** UTText\n")
let result9 = UTText()

console.print(string: "*** UTConsoleTest\n")
let result10 = UTConsoleTest()

console.print(string: "*** UTMath\n")
let result11 = UTMathTest(console: console)

console.print(string: "*** UTToken\n")
let result12 = UTTokenTest(console: console)

console.print(string: "*** UTObjectNotation\n")
let result13 = UTObjectNotation(console: console)

console.print(string: "*** UTObjectCoder\n")
let result14 = UTObjectCoder(console: console)

console.print(string: "*** UTShell\n")
let result15 = UTShell(console: console)

console.print(string: "*** UTCommandLine\n")
let result16 = UTCommandLine(console: console)

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 &&
	     result10 && result11 && result12 && result13 && result14 && result15 && result16
if result {
	console.print(string: "[SUMMARY] PASSED\n")
	exit(0)
} else {
	console.print(string: "[SUMMARY] Faield\n")
	exit(1)
}
