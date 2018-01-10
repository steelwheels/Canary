/**
 * @file	UTShell.swift
 * @brief	Unit test for CNSHell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public func UTShell(console cons: CNConsole) -> Bool
{
	let result0 = shellCommand(command: "/bin/echo Hello,World",	console: cons)
	let result1 = shellCommand(command: "/bin/ls *.plist",	console: cons)
	return result0 && result1
}

private func shellCommand(command cmd: String, console cons: CNConsole) -> Bool
{
	var result	= true

	cons.print(string: "shell: setup\n")
	let shell = CNShell()
	shell.command = cmd
	shell.terminationHandler = {
		(_ exitcode: Int32) -> Void in
			if exitcode != 0 {
				cons.print(string: "shell[ done -> Failed\n")
				result = false
			} else {
				cons.print(string: "shell: done -> Succeed\n")
			}
	}

	cons.print(string: "shell: execute\n")
	let pid = shell.execute(console: cons)
	if pid <= 0 {
		cons.print(string: "shell: Failed to execute")
		result = false
	}

	cons.print(string: "shell: wait command done\n")
	shell.waitUntilExit()
	
	cons.print(string: "shell: finish\n")
	
	return result
}

/*
private var mLsCommandDone	= false
private var mCatCommandDone	= false
private var mTraceiver		= false

public func UTShell(console cons: CNConsole) -> Bool
{
    let result0 = lsCommand(console: cons)
	while !(mLsCommandDone) { }

    let result1 = catCommand(console: cons)
	while !(mCatCommandDone) { }

	return result0 && result1
}

private func lsCommand(console cons: CNConsole) -> Bool
{
	let shell = CNShell()
	shell.arguments = ["/bin/ls"]

	let outpipe = Pipe()
	shell.output = outpipe
	outpipe.fileHandleForReading.readabilityHandler = readabilityHandler

	shell.terminationHandler = {
		(_ exitcode: Int32) -> Void in
		if exitcode != 0 {
            cons.print(string: "ls command done: Failed\n")
		}
		mLsCommandDone = true
	}

	let pid = shell.execute()
	if pid <= 0 {
        cons.print(string: "ls command start: Failed")
	}
	return true
}

private func catCommand(console cons: CNConsole) -> Bool
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
		if exitcode != 0 {
            cons.print(string: "cat command done: Failed")
		}
		mCatCommandDone = true
	}

	let pid = shell.execute()
	if pid <= 0 {
        cons.print(string: "cat command start: Failed")
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
		if line.characters.count > 0 {
			Swift.print("output: \"\(line)\"")
		}
	} else {
		Swift.print("Error decoding data: \(handle.availableData)")
	}
}
*/


