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
	case TokenizeError(Int, String)
	case ParseError(CNToken, String)

	public func description() -> String {
		let result: String
		switch self {
		case .NoError:
			result = "No error"
		case .TokenizeError(let lineno, let message):
			result = "Error: \(message) at line \(lineno)"
		case .ParseError(let token, let message):
			let lineno = token.lineNo
			let desc   = token.toString()
			result = "Error: \(message) at line \(lineno) near \"\(desc)\""
		}
		return result
	}
}
