/*
 * @file	CNShell.swift
 * @brief	Define CNShell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNShell
{
	public enum Status {
		case Idle
		case Running
		case Finished(code: Int32)

		public var description: String {
			var result: String
			switch self {
			case .Idle:			result = "Idle"
			case .Running:			result = "Running"
			case .Finished(let code):	result = "Finished(\(code))"
			}
			return result
		}
	}

	private var mShellCommand:	String
	private var mProcess:		Process?
	private var mStatus:		Status

	public var terminateHandler	: ((_ pid: Int32) -> Void)?
	public var outputHandler	: ((_ string: String) -> Void)?
	public var errorHandler		: ((_ string: String) -> Void)?
	public var status		: Status { get { return mStatus } }
	
	public init(command cmd: String){
		mShellCommand		= cmd
		mProcess		= nil
		mStatus			= .Idle
		terminateHandler	= nil
		outputHandler		= nil
		errorHandler		= nil
	}

	public func execute() -> Int32 {
		let process = Process()
		mProcess = process
		mStatus  = .Running

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
			if let termhdr = self.terminateHandler {
				termhdr(process.processIdentifier)
			}
			if let outpipe = process.standardOutput as? Pipe {
				//Swift.print("**** Close readabilityHandler for standardOutput")
				outpipe.fileHandleForReading.readabilityHandler = nil
			}
			if let errpipe = process.standardError as? Pipe {
				//Swift.print("**** Close readabilityHandler for standardError")
				errpipe.fileHandleForReading.readabilityHandler = nil
			}
			self.mStatus  = .Finished(code: process.terminationStatus)
			self.mProcess = nil
		}

		process.launch()
		return process.processIdentifier
	}

	public func processIdentifier() -> Int32? {
		if let process = mProcess {
			return process.processIdentifier
		} else {
			return nil
		}
	}

	public func waitUntilExit()
	{
		if let process = mProcess {
			process.waitUntilExit()
		}
	}
}

