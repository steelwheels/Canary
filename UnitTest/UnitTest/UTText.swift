/**
 * @file	UTText.swift
 * @brief	Unit test for CNText class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTText() -> Bool
{
	let line0 = CNTextLine(string: "")
	print(title: "Empty line", text: line0)

	line0.append(string: "ABCD")
	print(title: "Append \"ABCD\"to line", text: line0)

	let section0 = CNTextSection()
	print(title: "Empty section", text: section0)

	section0.add(text: line0)
	section0.add(string: ", EFGH")
	section0.addMultiLines(string: "1\n2\n3\n4")
	section0.append(string: "5")
	print(title: "Add line0", text: section0)

	let text1 = CNAddStringToText(text: line0, string: "Hello")
	let text2 = CNAddStringToText(text: text1, string: "World")
	print(title: "CNAddStringToText", text: text2)

	let text3 = CNAddStringsToText(text: CNTextLine(string: "abcd"), strings: ["Hello", ",World"])
	print(title: "CNAddStringsToText", text: text3)

	return true
}

private func print(title ttl: String, text txt: CNText)
{
	Swift.print("***** \(ttl) *****")
	txt.print(indent: 0)
}
