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
	private var mProcess		: Process? = nil

	public init(){
		arguments  	   = []
		terminationHandler = nil
		mProcess	   = nil
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
				self.mProcess = nil
			}
		} else {
			process.terminationHandler = {
				(process: Process) -> Void in
				self.mProcess = nil
			}
		}

		process.launch()
		return process.processIdentifier
	}

	public func waitUntilExit()
	{
		if let process = mProcess {
			if process.isRunning {
				process.waitUntilExit()
			}
		}
	}
}

#endif /* os(OSX) */

