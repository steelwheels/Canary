/*
 * @file	CNShell.swift
 * @brief	Define CNShell class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNShell
{
	private var mProcess		: Process
	private var mTerminationHandler	: ((_ exitcode: Int32) -> Void)?

	public init(){
		mProcess = Process()
		mProcess.launchPath = "/bin/sh"
	}

	public var arguments: Array<String> {
		get {
			if let args = mProcess.arguments {
				return args
			} else {
				return []
			}
		}
		set(args) {
			var fullargs = ["-c"]
			fullargs.append(contentsOf: args)
			mProcess.arguments = fullargs
		}
	}

	public var input: Pipe? {
		get {
			if let pipe = mProcess.standardInput as? Pipe {
				return pipe
			} else {
				return nil
			}
		}
		set(pipe){
			mProcess.standardInput = pipe
		}
	}

	public var output: Pipe? {
		get {
			if let pipe = mProcess.standardOutput as? Pipe {
				return pipe
			} else {
				return nil
			}
		}
		set(pipe){
			mProcess.standardOutput = pipe
		}
	}

	public var terminationHandler: ((_ exitcode: Int32) -> Void)? {
		get {
			return mTerminationHandler
		}
		set(handler){
			mTerminationHandler = handler
			if let handler = handler {
				mProcess.terminationHandler = {
					(process: Process) -> Void in
					handler(process.terminationStatus)
				}
			} else {
				mProcess.terminationHandler = nil
			}
		}
	}

	public func execute() -> Int32 {
		mProcess.launch()
		return mProcess.processIdentifier
	}

	public func waitUntilExit()
	{
		if mProcess.isRunning {
			mProcess.waitUntilExit()
		}
	}
}

