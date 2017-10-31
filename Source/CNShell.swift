/*
 * @file	CNShell.swift
 * @brief	Define CNShell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

#if os(OSX)

public class CNShell
{
	public var arguments		: Array<String>
	public var terminationHandler	: ((_ exitcode: Int32) -> Void)?

	public init(){
		arguments  	   = []
		terminationHandler = nil
	}

	public func execute(console cons: CNConsole) -> Int32 {
		let pipecons		= CNPipeConsole()
		pipecons.toConsole 	= cons
		
		let process  		= Process()
		process.launchPath	= "/bin/sh"

		var args =  ["-c"]
		args.append(contentsOf: arguments)
		process.arguments = args

		process.standardInput  = pipecons.outputPipe
		process.standardOutput = pipecons.inputPipe
		process.standardError  = pipecons.errorPipe

		if let handler = terminationHandler  {
			process.terminationHandler = {
				(process: Process) -> Void in
				handler(process.terminationStatus)
			}
		} else {
			process.terminationHandler = nil
		}

		process.launch()
		return process.processIdentifier
	}
	
	#if false
	public func waitUntilExit()
	{
		if mProcess.isRunning {
			mProcess.waitUntilExit()
		}
	}
	#endif
}

#endif /* os(OSX) */

