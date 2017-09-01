/**
 * @file	UTShell.swift
 * @brief	Unit test for CNSHell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

private var mLsCommandDone	= false
private var mCatCommandDone	= false
private var mTraceiver		= false

public func UTShell() -> Bool
{
	let result0 = lsCommand()
	while !(mLsCommandDone) { }

	let result1 = catCommand()
	while !(mCatCommandDone) { }

	return result0 && result1
}

private func lsCommand() -> Bool
{
	let shell = CNShell()
	shell.arguments = ["/bin/ls"]

	let outpipe = Pipe()
	shell.output = outpipe
	outpipe.fileHandleForReading.readabilityHandler = readabilityHandler

	shell.terminationHandler = {
		(_ exitcode: Int32) -> Void in
		if exitcode == 0 {
			Swift.print("command done: Succeed")
		} else {
			Swift.print("command done: Failed")
		}
		mLsCommandDone = true
	}

	let pid = shell.execute()
	if pid > 0 {
		Swift.print("command start: Succeed")
	} else {
		Swift.print("command start: Failed")
	}
	return true
}

private func catCommand() -> Bool
{
	let shell = CNShell()
	shell.arguments = ["/bin/cat"]

	let inpipe = Pipe()
	shell.input = inpipe

	let outpipe = Pipe()
	shell.output = outpipe
	outpipe.fileHandleForReading.readabilityHandler = readabilityHandler

	shell.terminationHandler = {
		(_ exitcode: Int32) -> Void in
		if exitcode == 0 {
			Swift.print("command done: Succeed")
		} else {
			Swift.print("command done: Failed")
		}
		mCatCommandDone = true
	}

	let pid = shell.execute()
	if pid > 0 {
		Swift.print("command start: Succeed")
	} else {
		Swift.print("command start: Failed")
	}

	var wcount = 0
	inpipe.fileHandleForWriting.writeabilityHandler = {
		(filehandle: FileHandle) -> Void in
		if wcount < 10 {
			let str = "\(wcount) Hello, world !\n"
			if let data = str.data(using: .utf8) {
				filehandle.write(data)
			}
			wcount += 1
		} else {
			filehandle.closeFile()
		}
	}

	return true
}

private var readabilityHandler: ((_ handle: FileHandle) -> Void) = {
	(_ handle: FileHandle) -> Void in
	if let line = String(data: handle.availableData, encoding: String.Encoding.utf8) {
		print("output: \"\(line)\"")
	} else {
		print("Error decoding data: \(handle.availableData)")
	}
}


