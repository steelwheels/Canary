/**
 * @file	CNReadLine.swift
 * @brief	Define CNReadLine class
 * @par Copyright
 *   Copyright (C) 2015-2018 Steel Wheels Project
 */

import Foundation

public class CNReadLine
{
	private var mPrompt:	String
	private var mBuffer:	String

	public init(){
		mPrompt	 = ""
		mBuffer  = ""
	}

	public func readLine() -> String {
		putPrompt()
		while true {
			if let str = getLine() {
				return str
			}
		}
	}

	public var prompt: String {
		get 	{ return mPrompt	}
		set(str){ mPrompt = str 	}
	}

	public func putPrompt() {
		let stdout = FileHandle.standardOutput
		if let data = mPrompt.data(using: .utf8) {
			stdout.write(data)
			stdout.synchronizeFile()
		}
	}

	public func getLine() -> String? {
		let stdin = FileHandle.standardInput
		let data  = stdin.availableData
		if let str = String(data: data, encoding: .utf8) {
			mBuffer.append(str)
			if let idx = mBuffer.index(of: "\n") {
				let prefix = mBuffer.prefix(upTo: idx)
				let suffix = mBuffer.suffix(from: idx)
				mBuffer = String(suffix)
				return String(prefix)
			}
		} else {
			NSLog("Failed to read stdin")
		}
		return nil
	}
}

