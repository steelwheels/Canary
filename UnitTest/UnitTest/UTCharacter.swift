/**
 * @file	UTCharacter.swift
 * @brief	Unit test for Character class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTCharacter(console cons: CNConsole) -> Bool
{
	var result	: Bool      = true
	let ca		: Character = "a"
	let cspace	: Character = " "
	let c4		: Character = "4"

	result = result && checkResult(message: "isSpace(\(cspace))", realResult: cspace.isSpace(), expectedResult: true, console: cons)
	result = result && checkResult(message: "isSpace(\(ca))", realResult: ca.isSpace(), expectedResult: false, console: cons)

	result = result && checkResult(message: "isDigit(\(c4))", realResult: c4.isDigit(), expectedResult: true, console: cons)
	result = result && checkResult(message: "isDigit(\(ca))", realResult: ca.isDigit(), expectedResult: false, console: cons)

	result = result && checkResult(message: "isHex(\(c4))", realResult: c4.isHex(), expectedResult: true, console: cons)
	result = result && checkResult(message: "isHex(\(ca))", realResult: ca.isHex(), expectedResult: true, console: cons)

	result = result && checkResult(message: "isAlphaOrNum(\(c4))", realResult: c4.isAlphaOrNum(), expectedResult: true, console: cons)
	result = result && checkResult(message: "isAlphaOrNum(\(ca))", realResult: ca.isAlphaOrNum(), expectedResult: true, console: cons)
	result = result && checkResult(message: "isAlphaOrNum(\(cspace))", realResult: cspace.isAlphaOrNum(), expectedResult: false, console: cons)

	return result
}

private func checkResult(message msg: String, realResult realval: Bool, expectedResult expval: Bool, console cons: CNConsole) -> Bool {

	if realval == expval {
		cons.print(string: "test: \(msg) == \(expval) -> OK\n")
		return true
	} else {
		cons.print(string: "test: \(msg) == \(expval) -> NG\n")
		return false
	}
}
