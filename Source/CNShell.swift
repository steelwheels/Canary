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
	public class func execute(command cmd: String, inputFile infile: CNFile, outputFile outfile: CNFile, errorFile errfile: CNFile, terminateHandler termhdl: ((_ exitcode: Int32) -> Void)?) -> Process {
		let process  		= Process()
		process.launchPath	= "/bin/sh"

		let inpipe 		= Pipe()
		let outpipe		= Pipe()
		let errpipe		= Pipe()

		inpipe.fileHandleForWriting.writeabilityHandler = {
			(_ handle: FileHandle) -> Void in
			let data = infile.getData()
			handle.write(data)
		}

		outpipe.fileHandleForReading.readabilityHandler = {
			(_ handle: FileHandle) -> Void in
			let data = handle.availableData
			let _ = outfile.put(data: data)
		}

		errpipe.fileHandleForReading.readabilityHandler = {
			(_ handle: FileHandle) -> Void in
			let data = handle.availableData
			let _ = errfile.put(data: data)
		}
		
		process.arguments	= ["-c", cmd]
		process.standardInput	= inpipe
		process.standardOutput	= outpipe
		process.standardError	= errpipe

		if let handler = termhdl  {
			process.terminationHandler = {
				(process: Process) -> Void in
				handler(process.terminationStatus)
			}
		}

		process.launch()
		return process
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

