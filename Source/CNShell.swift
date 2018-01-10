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
	public var command		: String
	public var terminationHandler	: ((_ exitcode: Int32) -> Void)?
	private var mProcess		: Process? = nil
	private var mPipeConsole	: CNPipeConsole? = nil

	public init(){
		command  	   = ""
		terminationHandler = nil
		mProcess	   = nil
		mPipeConsole	   = nil
	}

	public func execute(console cons: CNConsole) -> Int32 {
		if command.utf8.count == 0 {
			return -1
		}

		let pipecons		= CNPipeConsole()
		pipecons.toConsole	= cons
		mPipeConsole		= pipecons

		let process  		= Process()
		process.launchPath	= "/bin/sh"
		mProcess		= process

		process.arguments	= ["-c", command]
		process.standardInput	= pipecons.outputPipe
		process.standardOutput	= pipecons.inputPipe
		process.standardError	= pipecons.errorPipe

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

