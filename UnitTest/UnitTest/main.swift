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
if !result0 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTStream\n")
let result17 = UTStream(console: console)
if !result17 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTListTest\n")
let result1 = UTListTest(console: console)
if !result1 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTGraphTest\n")
let result2 = UTGraphTest(console: console)
if !result2 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTStackTest\n")
let result3 = UTStackTest(console: console)
if !result3 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTNumber\n")
let result4 = UTNumber(console: console)
if !result4 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTValue\n")
let result5 = UTValueTest(console: console)
if !result5 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTValueTable\n")
let result6 = UTValueTableTest(console: console)
if !result6 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTURLTest\n")
let result7 = UTURLTest(console: console)
if !result7 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTStateTest\n")
let result8 = UTStateTest(console: console) && UTTristateTest(console: console)
if !result8 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTText\n")
let result9 = UTText()
if !result9 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTConsoleTest\n")
let result10 = UTConsoleTest(console: console)
if !result10 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTMath\n")
let result11 = UTMathTest(console: console)
if !result11 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTToken\n")
let result12 = UTTokenTest(console: console)
if !result12 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTObjectNotation\n")
let result13 = UTObjectNotation(console: console)
if !result13 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTObjectCoder\n")
let result14 = UTObjectCoder(console: console)
if !result14 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTJSONFile\n")
let result20 = UTJSONFile(console: console)
if !result20 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTShell\n")
let result15 = UTShell(console: console)
if !result15 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTCommandLine\n")
let result16 = UTCommandLine(console: console)
if !result16 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTPropertyList\n")
let result18 = UTPropertyListTest(console: console)
if !result18 { console.print(string: "result: Failed\n") }

console.print(string: "*** UTFile\n")
let result19 = UTFileTest(console: console)
if !result19 { console.print(string: "result: Failed\n") }

let result = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 &&
	     result10 && result11 && result12 && result13 && result14 && result15 && result16 && result17 && result18 &&
	     result19 && result20
if result {
	console.print(string: "[SUMMARY] PASSED\n")
	exit(0)
} else {
	console.print(string: "[SUMMARY] Faield\n")
	exit(1)
}
