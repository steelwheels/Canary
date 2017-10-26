/**
 * @file	UTList.swift
 * @brief	Unit test for CNList class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTStackTest(console cons: CNConsole) -> Bool
{
	let stack = CNStack<Int>()
	printStack(stack: stack, console: cons)

    cons.print(string: "* push 1\n")
	stack.push(1)
	printStack(stack: stack, console: cons)

    cons.print(string: "* push 2\n")
	stack.push(2)
	printStack(stack: stack, console: cons)

    cons.print(string: "* pop\n")
	if let p0 = stack.pop() {
        cons.print(string: "Poped: \(p0)\n")
	}
	printStack(stack: stack, console: cons)

    cons.print(string: "* pop\n")
	if let p1 = stack.pop() {
        cons.print(string: "Poped: \(p1)\n")
	}
	printStack(stack: stack, console: cons)

    cons.print(string: "* pop\n")
	if let p2 = stack.pop() {
        cons.print(string: "Poped: \(p2)\n")
	}
	printStack(stack: stack, console: cons)

	return true
}

private func printStack(stack s: CNStack<Int>, console cons: CNConsole)
{
	if let v = s.peekTop() {
		cons.print(string: "Top: \(v)\n")
	} else {
		cons.print(string: "Top: None\n")
	}
}
