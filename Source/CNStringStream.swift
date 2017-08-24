/**
 * @file	CNStringStream.h
 * @brief	Define CNStringStream class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNStingStream
{
	private var mString:		String
	private var mStartIndex:	String.Index
	private var mEndIndex:		String.Index

	public init(string src: String){
		mString		= src
		mStartIndex	= src.startIndex
		mEndIndex	= src.endIndex
	}

	public func getc() -> Character? {
		if mStartIndex < mEndIndex {
			let c: Character = mString[mStartIndex]
			mStartIndex = mString.index(after: mStartIndex)
			return c
		} else {
			return nil
		}
	}

	public func ungetc() -> Character? {
		if mString.startIndex < mStartIndex {
			mStartIndex = mString.index(before: mStartIndex)
			return mString[mStartIndex]
		} else {
			return nil
		}
	}

	public func trace(trace trc: (Character) -> Bool) -> String {
		var result: String = ""
		while true {
			if let c = getc() {
				if trc(c) {
					result.append(c)
				} else {
					_ = ungetc()
					return result
				}
			} else {
				return result
			}
		}
	}
}
