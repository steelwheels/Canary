/**
 * @file	UTShell.swift
 * @brief	Unit test for CNSHell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

private var mStaticPid: Int32 = -1

public func UTShell() -> Bool
{
	let result0 = testShell0()
	let result1 = testShell1()
	return result0 && result1
}

private func testShell0() -> Bool
{
	let shell = CNShell(command: "/bin/ls")
	setHandler(shell: shell)
	let pid = shell.execute()
	shell.waitUntilExit()
	if pid != mStaticPid {
		Swift.print("[Error] Unmatched pid: \(pid) != \(mStaticPid)")
	}
	return true
}

private func testShell1() -> Bool
{
	let shell = CNShell(command: "/bin/lsx")
	setHandler(shell: shell)
	let pid = shell.execute()
	shell.waitUntilExit()
	if pid != mStaticPid {
		Swift.print("[Error] Unmatched pid: \(pid) != \(mStaticPid)")
	}
	return true
}

private func setHandler(shell sh: CNShell)
{
	sh.outputHandler = {
		(_ string: String) -> Void in
		Swift.print("[UTShell] output = \(string)")
	}
	sh.errorHandler = {
		(_ string: String) -> Void in
		Swift.print("[UTShell] error = \(string)")
	}
	sh.terminationHandler = {
		(_ pid: Int32) -> Void in
		Swift.print("[UTShell] Iterminated")
		mStaticPid = pid
	}
}

