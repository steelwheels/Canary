/**
 * @file	UTList.swift
 * @brief	Unit test for CNList class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTStackTest() -> Bool
{
	let stack = CNStack<Int>()
	printStack(stack: stack)

	Swift.print("* push 1")
	stack.push(1)
	printStack(stack: stack)

	Swift.print("* push 2")
	stack.push(2)
	printStack(stack: stack)

	Swift.print("* pop")
	if let p0 = stack.pop() {
		Swift.print("Poped: \(p0)")
	}
	printStack(stack: stack)

	Swift.print("* pop")
	if let p1 = stack.pop() {
		Swift.print("Poped: \(p1)")
	}
	printStack(stack: stack)

	Swift.print("* pop")
	if let p2 = stack.pop() {
		Swift.print("Poped: \(p2)")
	}
	printStack(stack: stack)

	return true
}

private func printStack(stack s: CNStack<Int>)
{
	if let v = s.peekTop() {
		Swift.print("Top: \(v)")
	} else {
		Swift.print("Top: None")
	}
}
