/**
 * @file	UTStream.swift
 * @brief	Unit test for CNStringStream, CNArrayStream class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTStream(console cons: CNConsole) -> Bool
{
	console.print(string: "**** testStringStream ****\n")
	let res0 = testStringStream(console: cons)
	console.print(string: "**** testArrayStream ****\n")
	let res1 = testArrayStream(console: cons)
	return res0 && res1
}

private func testStringStream(console cons: CNConsole) -> Bool
{
	let stream0 = CNStringStream(string: "0123456789")
	let count0  = stream0.count

	/* peek */
	console.print(string: "* peek\n")
	for i in 0..<count0 {
		if let c = stream0.peek(offset: i) {
			console.print(string: "\(i):\(c) ")
		} else {
			console.print(string: "\(i):EOF ")
		}
	}
	console.print(string: "\n")

	/* getc */
	console.print(string: "* getc\n")
	if let c = stream0.getc() {
		console.print(string: "c=\(c)\n")
	} else {
		console.print(string: "c=EOF\n")
	}

	/* gets */
	console.print(string: "* gets: 5\n")
	let s = stream0.gets(count: 5)
	console.print(string: "s=\(s)\n")

	/* ungetc */
	console.print(string: "* ungetc\n")
	if let c = stream0.ungetc() {
		console.print(string: "c=\(c)\n")
	} else {
		console.print(string: "c=EOF\n")
	}

	return true
}

private func testArrayStream(console cons: CNConsole) -> Bool
{
	let stream0 = CNArrayStream(source: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
	let count0  = stream0.count

	/* peek */
	console.print(string: "* peek\n")
	for i in 0..<count0 {
		if let d = stream0.peek(offset: i) {
			console.print(string: "\(i):\(d) ")
		} else {
			console.print(string: "\(i):EOF ")
		}
	}
	console.print(string: "\n")

	/* get */
	console.print(string: "* get\n")
	if let d = stream0.get() {
		console.print(string: "d=\(d)\n")
	} else {
		console.print(string: "d=EOF\n")
	}

	/* get */
	console.print(string: "* get: 5\n")
	let d = stream0.get(count: 5)
	console.print(string: "d=\(d)\n")

	/* unget */
	console.print(string: "* unget\n")
	if let d = stream0.unget() {
		console.print(string: "d=\(d)\n")
	} else {
		console.print(string: "d=EOF\n")
	}

	return true
}

