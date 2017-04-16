/**
 * @file	UTCharacter.swift
 * @brief	Unit test for Character class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTCharacter() -> Bool
{
	var result	: Bool      = true
	let ca		: Character = "a"
	let cspace	: Character = " "
	let c4		: Character = "4"

	result = result && checkResult(message: "isSpace(\(cspace))", realResult: cspace.isSpace(), expectedResult: true)
	result = result && checkResult(message: "isSpace(\(ca))", realResult: ca.isSpace(), expectedResult: false)

	result = result && checkResult(message: "isDigit(\(c4))", realResult: c4.isDigit(), expectedResult: true)
	result = result && checkResult(message: "isDigit(\(ca))", realResult: ca.isDigit(), expectedResult: false)

	result = result && checkResult(message: "isHex(\(c4))", realResult: c4.isHex(), expectedResult: true)
	result = result && checkResult(message: "isHex(\(ca))", realResult: ca.isHex(), expectedResult: true)

	result = result && checkResult(message: "isAlphaOrNum(\(c4))", realResult: c4.isAlphaOrNum(), expectedResult: true)
	result = result && checkResult(message: "isAlphaOrNum(\(ca))", realResult: ca.isAlphaOrNum(), expectedResult: true)
	result = result && checkResult(message: "isAlphaOrNum(\(cspace))", realResult: cspace.isAlphaOrNum(), expectedResult: false)

	return result
}

private func checkResult(message msg: String, realResult realval: Bool, expectedResult expval: Bool) -> Bool {

	if realval == expval {
		print("test: \(msg) == \(expval) -> OK")
		return true
	} else {
		print("test: \(msg) == \(expval) -> NG")
		return false
	}
}
