/**
 * @file	CNParser.swift
 * @brief	Define CNParser class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNParseError: Error
{
	case NoError
	case ParseError(Int, String)

	public func description() -> String {
		let result: String
		switch self {
		case .NoError:
			result = "No error"
		case .ParseError(let line, let message):
			result = "Error: \(message) at line \(line)"
		}
		return result
	}
}
