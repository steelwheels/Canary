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
	let result2 = searchCommand(commandName: "ls", console: cons)
	let result3 = searchCommand(commandName: "github", console: cons)
	return result0 && result1 && result2 && result3
}

private func shellCommand(command cmd: String, console cons: CNConsole) -> Bool
{
	var result	= true

	cons.print(string: "shell: setup\n")
	let shell = CNShell()
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
	let pid = shell.execute(command: cmd, console: cons)
	if pid <= 0 {
		cons.print(string: "shell: Failed to execute")
		result = false
	}

	cons.print(string: "shell: wait command done\n")
	shell.waitUntilExit()
	
	cons.print(string: "shell: finish\n")
	
	return result
}

private func searchCommand(commandName name: String, console cons: CNConsole) -> Bool
{
	let result: Bool
	cons.print(string: "shell: search command \"name\" => ")
	if let path = CNShell.searchCommand(commandName: name) {
		cons.print(string: "FOUND: \"\(path)\"\n")
		result = true
	} else {
		cons.print(string: "NOT-FOUND\n")
		result = false
	}
	return result
}



