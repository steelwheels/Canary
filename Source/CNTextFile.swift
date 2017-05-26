/*
 * @file	CNTextFile.swift
 * @brief	Extend CNFileURL class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNFileKind {
	case StandardInput
	case StandardOutput
	case StandardError
}

public class CNTextFile
{
	public static let stdin  = CNTextFile(kind: .StandardInput)
	public static let stdout = CNTextFile(kind: .StandardOutput)
	public static let stderr = CNTextFile(kind: .StandardError)

	public var kind		: CNFileKind
	private var mFileHandle	: FileHandle

	public init(kind k: CNFileKind){
		kind = k
		switch k {
		case .StandardInput:	mFileHandle = FileHandle.standardInput
		case .StandardOutput:	mFileHandle = FileHandle.standardOutput
		case .StandardError:	mFileHandle = FileHandle.standardError
		}
	}

	public func print(string str: String){
		let outdata = str.data(using: .utf8)
		if let data = outdata {
			mFileHandle.write(data)
		}
	}
}
