/*
 * @file	CNShell.swift
 * @brief	Define CNShell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNShell
{
	private var mShellCommand:	String
	private var mProcess:		Process?

	public var terminationHandler	: (() -> Void)?
	public var outputHandler	: ((_ string: String) -> Void)?
	public var errorHandler		: ((_ string: String) -> Void)?

	public init(command cmd: String){
		mShellCommand		= cmd
		mProcess		= nil
		terminationHandler	= nil
		outputHandler		= nil
		errorHandler		= nil
	}

	public func execute(){
		let process = Process()
		mProcess = process

		let args = ["-c", mShellCommand]
		process.launchPath = "/bin/sh"
		process.arguments  = args

		if let userouthdr = outputHandler {
			let outpipe = Pipe()
			let pipehandle = outpipe.fileHandleForReading
			pipehandle.readabilityHandler = {
				(handler: FileHandle) -> Void in
				if let line = String(data: handler.availableData, encoding: .utf8) {
					userouthdr(line)
				} else {
					NSLog("Error decoding data: \(handler.availableData)")
				}
			}
			process.standardOutput = outpipe
		}

		if let usererrhdr = errorHandler {
			let errpipe = Pipe()
			let pipehandle = errpipe.fileHandleForReading
			pipehandle.readabilityHandler = {
				(handler: FileHandle) -> Void in
				if let line = String(data: handler.availableData, encoding: .utf8) {
					usererrhdr(line)
				} else {
					NSLog("Error decoding data: \(handler.availableData)")
				}
			}
			process.standardError = errpipe
		}

		process.terminationHandler = {
			(process: Process) -> Void in
			if let termhdr = self.terminationHandler {
				termhdr()
			}
			if let outpipe = process.standardOutput as? Pipe {
				//Swift.print("**** Close readabilityHandler")
				outpipe.fileHandleForReading.readabilityHandler = nil
			}
			self.mProcess = nil
		}

		process.launch()
	}

	public func waitUntilExit()
	{
		if let process = mProcess {
			process.waitUntilExit()
		}
	}
}

