/*
 * @file	CNShell.swift
 * @brief	Define CNShell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

@objc public class CNShell: NSObject
{
	@objc public enum Status: Int {
		case Idle		= 0
		case CouldNotLaunch	= 1
		case Running		= 2
		case Succeed		= 3
		case Failed		= 4

		public var description: String {
			get {
				var result = "?"
				switch self {
				case .Idle:		result = "Idle"
				case .CouldNotLaunch:	result = "CouldNotLaunch"
				case .Running:		result = "Running"
				case .Succeed:		result = "Succeed"
				case .Failed:		result = "Failed"
				}
				return result
			}
		}
	}

	private var mShellCommand:	String
	private var mProcess:		Process?

	public var terminateHandler	: ((_ pid: Int32) -> Void)?
	public var outputHandler	: ((_ string: String) -> Void)?
	public var errorHandler		: ((_ string: String) -> Void)?

	public dynamic var status	: Status

	public init(command cmd: String){
		status			= .Idle
		mShellCommand		= cmd
		mProcess		= nil
		terminateHandler	= nil
		outputHandler		= nil
		errorHandler		= nil
	}

	public func execute() -> Int32
	{
		if mProcess != nil {
			status = .CouldNotLaunch
			return -1
		}

		let process = Process()
		mProcess = process
		status  = .Running

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
			if process.terminationStatus == 0 {
				self.status = .Succeed
			} else {
				self.status = .Failed
			}
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

