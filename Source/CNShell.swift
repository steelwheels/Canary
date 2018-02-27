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
	public var terminationHandler	: ((_ exitcode: Int32) -> Void)?
	private var mProcess		: Process? = nil

	public init(){
		terminationHandler = nil
		mProcess	   = nil
	}

	public func execute(command cmd: String, console cons: CNConsole) -> Int32 {
		if cmd.utf8.count == 0 {
			return -1
		}

		let pipecons		= CNPipeConsole()
		pipecons.toConsole	= cons

		let process  		= Process()
		process.launchPath	= "/bin/sh"
		mProcess		= process

		process.arguments	= ["-c", cmd]
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

	private static var commandTable: Dictionary<String, String> = [:]

	public class func searchCommand(commandName name: String) -> String? {
		if let cmdpath = commandTable[name] {
			return cmdpath
		} else if let pathstr = ProcessInfo.processInfo.environment["PATH"] {
			let fmanager = FileManager.default

			let pathes = pathstr.components(separatedBy: ":")
			for path in pathes {
				let cmdpath = path + "/" + name
				if fmanager.fileExists(atPath: cmdpath) {
					if fmanager.isExecutableFile(atPath: cmdpath) {
						commandTable[name] = cmdpath
						return cmdpath
					}
				}
			}
		}
		return nil
	}
}

#endif /* os(OSX) */

