/*
 * @file	CNTextFile.swift
 * @brief	Extend CNFileURL class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNFileAccessType {
	case ReadAccess
	case WriteAccess
	case AppendAccess
}

public func CNOpenFile(filePath path: String, accessType acctyp: CNFileAccessType) -> (CNFile?, NSError?)
{
	do {
		var file: CNFile
		switch acctyp {
		case .ReadAccess:
			let fileurl = pathToURL(filePath: path)
			let handle = try FileHandle(forReadingFrom: fileurl)
			file = CNReadFile(fileHandle: handle)
		case .WriteAccess:
			let handle = try fileHandleToWrite(filePath: path, withAppend: false)
			file = CNWriteFile(fileHandle: handle)
		case .AppendAccess:
			let handle = try fileHandleToWrite(filePath: path, withAppend: true)
			file = CNWriteFile(fileHandle: handle)
		}
		return (file, nil)
	} catch let err as NSError {
		return (nil, err)
	} catch {
		let err = NSError.fileError(message: "Failed to open file \"\(path)\"")
		return (nil, err)
	}
}

public enum CNStandardFileType {
	case input
	case output
	case error
}

public func CNStandardFile(type t: CNStandardFileType) -> CNFile
{
	var file: CNFile
	switch t {
	case .input:	file = CNReadFile (fileHandle: FileHandle.standardInput)
	case .output:	file = CNWriteFile(fileHandle: FileHandle.standardOutput)
	case .error:	file = CNWriteFile(fileHandle: FileHandle.standardError)
	}
	return file
}

private func pathToURL(filePath path: String) -> URL {
	let curdir = FileManager.default.currentDirectoryPath
	let cururl = URL(fileURLWithPath: curdir, isDirectory: true)
	return URL(fileURLWithPath: path, relativeTo: cururl)
}

private func fileHandleToWrite(filePath path: String, withAppend doappend: Bool) throws -> FileHandle
{
	let fmanager = FileManager.default
	if !fmanager.fileExists(atPath: path) {
		fmanager.createFile(atPath: path, contents: nil, attributes: nil)
	}
	let url = pathToURL(filePath: path)
	let handle = try FileHandle(forWritingTo: url)
	if doappend {
		handle.seekToEndOfFile()
	}
	return handle
}

@objc public class CNFile: NSObject
{
	public var fileHandle:		FileHandle?

	public init(fileHandle handle: FileHandle){
		fileHandle = handle
	}

	deinit {
		close()
	}

	public func close() {
		if let handle = fileHandle {
			handle.closeFile()
			fileHandle = nil
		}
	}

	public var isClosed: Bool {
		get { return fileHandle == nil }
	}

	public func getChar() -> Character? {
		return nil
	}

	public func getLine() -> String? {
		return nil
	}

	public func put(char c: Character) -> Int {
		/* Do nothing */
		return 0
	}

	public func put(string s: String) -> Int {
		/* Do nothing */
		return 0
	}
}

private class CNReadFile: CNFile
{
	public static let 		CHUNK_SIZE = 512
	private var mLineBuffer:	CNLineBuffer

	public override init(fileHandle handle: FileHandle) {
		mLineBuffer = CNLineBuffer()
		super.init(fileHandle: handle)
	}

	public override func getChar() -> Character? {
		if let handle = fileHandle {
			while true {
				if let c = mLineBuffer.getChar() {
					return c
				} else {
					let newdata = handle.readData(ofLength: CNLineBuffer.CHUNK_SIZE)
					if newdata.count == 0 {
						/* end of file */
						close()
						return nil
					} else {
						mLineBuffer.appendData(data: newdata)
					}
				}
			}
		} else {
			return nil
		}
	}

	public override func getLine() -> String? {
		if let _ = fileHandle {
			var result: String?	= nil
			while true {
				if let c = getChar() {
					var newres: String
					if let str = result {
						newres = str
					} else {
						newres = ""
					}
					newres.append(c)
					if c == "\n" {
						return newres
					}
					result = newres
				} else {
					return result
				}
			}
		} else {
			return nil
		}
	}
}

private class CNWriteFile: CNFile
{
	public override func put(char c: Character) -> Int {
		if let handle = fileHandle {
			let str  = String(c)
			if let data = str.data(using: .utf8) {
				handle.write(data)
			} else {
				NSLog("Failed to put")
			}
		}
		return 1
	}

	public override func put(string s: String) -> Int {
		if let handle = fileHandle {
			if let data = s.data(using: .utf8) {
				handle.write(data)
				return s.count
			} else {
				NSLog("Failed to put")
			}
		}
		return 0
	}
}

private class CNLineBuffer
{
	public static let 	CHUNK_SIZE = 512
	private var 		mBuffer: 	String
	private var		mReadPoint:	String.Index
	private var		mReadCount:	Int

	public init(){
		mBuffer    = ""
		mReadPoint = mBuffer.startIndex
		mReadCount = 0
	}

	public func appendData(data d: Data) {
		if let str = String(data: d, encoding: .utf8) {
			mBuffer.append(str)
		} else {
			NSLog("Failed to append")
		}
	}

	public func getChar() -> Character? {
		if mReadPoint < mBuffer.endIndex {
			let c = mBuffer[mReadPoint]
			if mReadCount > CNLineBuffer.CHUNK_SIZE {
				mBuffer.removeSubrange(mBuffer.startIndex..<mReadPoint)
				mReadPoint = mBuffer.startIndex
				mReadCount = 0
			} else {
				mReadPoint = mBuffer.index(after: mReadPoint)
				mReadCount += 1
			}
			return c
		} else {
			return nil
		}
	}
}

