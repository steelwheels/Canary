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
	let console = CNFileConsole(file: CNTextFile.stdout)

	let line0 = CNTextLine(string: "")
	print(console: console, title: "Empty line", text: line0)

	line0.append(string: "ABCD")
	print(console: console, title: "Append \"ABCD\"to line", text: line0)

	let section0 = CNTextSection()
	print(console: console, title: "Empty section", text: section0)

	section0.add(text: line0)
	section0.add(string: ", EFGH")
	section0.addMultiLines(string: "1\n2\n3\n4")
	section0.append(string: "5")
	print(console: console, title: "Add line0", text: section0)

	let text1 = CNAddStringToText(text: line0, string: "Hello")
	let text2 = CNAddStringToText(text: text1, string: "World")
	print(console: console, title: "CNAddStringToText", text: text2)

	let text3 = CNAddStringsToText(text: CNTextLine(string: "abcd"), strings: ["Hello", ",World"])
	print(console: console, title: "CNAddStringsToText", text: text3)

	return true
}

private func print(console cons: CNConsole, title ttl: String, text txt: CNText)
{
	Swift.print("***** \(ttl) *****")
	txt.print(console: cons, indent: 0)
}
