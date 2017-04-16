/**
 * @file	CNToken.swift
 * @brief	Define CNToken class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNTokenType {
	case SymbolToken(Character)
	case IdentifierToken(String)
	case BoolToken(Bool)
	case UIntToken(UInt)
	case IntToken(Int)
	case FloatToken(Double)
	case StringToken(String)
	case TextToken(String)

	public func description() -> String {
		let result: String
		switch self {
		case .SymbolToken(let val):
			result = "SymbolToken(\(val))"
		case .IdentifierToken(let val):
			result = "IdentifierToken(\(val))"
		case .BoolToken(let val):
			result = "BoolToken(\(val))"
		case .IntToken(let val):
			result = "IntToken(\(val))"
		case .UIntToken(let val):
			result = "UIntToken(\(val))"
		case .FloatToken(let val):
			result = "FloatToken(\(val))"
		case .StringToken(let val):
			result = "StringToken(\(val))"
		case .TextToken(let val):
			result = "TextToken(\(val))"
		}
		return result
	}


}

public struct CNToken {
	private var mType:	CNTokenType
	private var mLineNo:	Int

	public init(type t: CNTokenType, lineNo no: Int){
		mType   = t
		mLineNo = no
	}

	public var type: CNTokenType { return mType }
	public var lineNo: Int { return mLineNo }

	public var description: String {
		return mType.description()
	}

	public func getSymbol() -> Character? {
		let result: Character?
		switch self.type {
		case .SymbolToken(let c):
			result = c
		default:
			result = nil
		}
		return result
	}

	public func getIdentifier() -> String? {
		let result: String?
		switch self.type {
		case .IdentifierToken(let s):
			result = s
		default:
			result = nil
		}
		return result
	}

	public func getBool() -> Bool? {
		let result: Bool?
		switch self.type {
		case .BoolToken(let v):
			result = v
		default:
			result = nil
		}
		return result
	}

	public func getInt() -> Int? {
		let result: Int?
		switch self.type {
		case .IntToken(let v):
			result = v
		default:
			result = nil
		}
		return result
	}

	public func getUInt() -> UInt? {
		let result: UInt?
		switch self.type {
		case .UIntToken(let v):
			result = v
		default:
			result = nil
		}
		return result
	}

	public func getFloat() -> Double? {
		let result: Double?
		switch self.type {
		case .FloatToken(let v):
			result = v
		default:
			result = nil
		}
		return result
	}

	public func getString() -> String? {
		let result: String?
		switch self.type {
		case .StringToken(let s):
			result = s
		default:
			result = nil
		}
		return result
	}

	public func getText() -> String? {
		let result: String?
		switch self.type {
		case .TextToken(let s):
			result = s
		default:
			result = nil
		}
		return result
	}
}

public func CNStringToToken(string srcstr: String) -> (CNParseError, Array<CNToken>)
{
	let tokenizer = CNTokenizer()
	return tokenizer.tokenize(string: srcstr)
}

private class CNTokenizer
{
	var mCurrentLine: Int

	public init(){
		mCurrentLine = 1
	}

	public func tokenize(string srcstr: String) -> (CNParseError, Array<CNToken>) {
		do {
			let tokens = try stringToTokens(string: srcstr)
			return (.NoError, tokens)
		} catch let error {
			if let tkerr = error as? CNParseError {
				return (tkerr, [])
			} else {
				fatalError("Unknown error")
			}
		}
	}

	private func stringToTokens(string srcstr: String) throws -> Array<CNToken> {
		mCurrentLine = 1

		var srcrange = srcstr.startIndex ..< srcstr.endIndex
		var result : Array<CNToken> = []

		while true {
			let range0 = skipSpaces(range: srcrange, string: srcstr)
			if isEndOfString(range: srcrange) {
				break
			}
			let (token, range1) = try getTokenFromString(range: range0, string: srcstr)
			result.append(token)
			srcrange = range1
		}
		return result
	}

	private func isEndOfString(range src: Range<String.Index>) -> Bool {
		return !(src.lowerBound < src.upperBound)
	}

	private func getTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) throws -> (CNToken, Range<String.Index>) {
		let (c1p, range1) = getChar(range: srcrange, string: srcstr)
		if let c1 = c1p {
			if c1 == "0" {
				let (c2p, _) = getChar(range: range1, string: srcstr)
				if let c2 = c2p {
					switch c2 {
					case ".":
						return try getDigitTokenFromString(range: srcrange, string: srcstr)
					case "x", "X":
						return try getHexTokenFromString(range: srcrange, string: srcstr)
					default:
						let token = CNToken(type: .UIntToken(0), lineNo: mCurrentLine)
						return (token, range1)
					}
				} else {
					let token = CNToken(type: .UIntToken(0), lineNo: mCurrentLine)
					return (token, range1)
				}
			} else if c1.isDigit() {
				return try getDigitTokenFromString(range: srcrange, string: srcstr)
			} else if c1.isAlpha() || c1 == "_" {
				return getIdentifierTokenFromString(range: srcrange, string: srcstr)
			} else if c1 == "\"" {
				return try getStringTokenFromString(range: srcrange, string: srcstr)
			} else if c1 == "%" {
				let (c2p, _) = getChar(range: range1, string: srcstr)
				if let c2 = c2p {
					switch c2 {
					case "{":
						return try getTextTokenFromString(range: srcrange, string: srcstr)
					default:
						let token = CNToken(type: .SymbolToken(c1), lineNo: mCurrentLine)
						return (token, range1)
					}
				} else {
					let token = CNToken(type: .SymbolToken(c1), lineNo: mCurrentLine)
					return (token, range1)
				}
			} else {
				if c1 == "\n" {
					mCurrentLine += 1
				}
				let token = CNToken(type: .SymbolToken(c1), lineNo: mCurrentLine)
				return (token, range1)
			}
		} else {
			fatalError("Can not reach here")
		}
	}

	private func skipSpaces(range srcrange: Range<String.Index>, string srcstr: String) -> Range<String.Index>
	{
		var idx  = srcrange.lowerBound
		let eidx = srcrange.upperBound
		while idx < eidx {
			if srcstr[idx].isSpace() {
				idx = srcstr.index(after: idx)
				if srcstr[idx] == "\n" { mCurrentLine += 1 }
			} else {
				break
			}
		}
		return (idx..<eidx)
	}

	private func getChar(range srcrange: Range<String.Index>, string srcstr: String) -> (Character?, Range<String.Index>)
	{
		let sidx = srcrange.lowerBound
		let eidx = srcrange.upperBound
		if sidx < eidx {
			let nidx = srcstr.index(after: sidx)
			return (srcstr[sidx], nidx..<eidx)
		} else {
			return (nil, srcrange)
		}
	}

	private func getDigitTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) throws -> (CNToken, Range<String.Index>) {
		var hasperiod = false
		let (resstr, resrange) = getAnyTokenFromString(range: srcrange, string: srcstr, matchingFunc: {
			(_ c: Character) -> Bool in
			if c.isDigit() {
				return true
			} else if c == "." {
				hasperiod = true
				return true
			} else {
				return false
			}
		})
		if hasperiod {
			if let value = Double(resstr) {
				return (CNToken(type:.FloatToken(value), lineNo: mCurrentLine), resrange)
			} else {
				throw CNParseError.ParseError(mCurrentLine, "Double value is expected but \"\(resstr)\" is given")
			}
		} else {
			if let value = UInt(resstr) {
				return (CNToken(type: .UIntToken(value), lineNo: mCurrentLine), resrange)
			} else {
				throw CNParseError.ParseError(mCurrentLine, "Integer value is expected but \"\(resstr)\" is given")
			}
		}
	}

	private func getHexTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) throws -> (CNToken, Range<String.Index>) {
		/* Check the source string is started by "0x" */
		var hasprefix		: Bool = false
		var skippedrange	: Range<String.Index> = srcrange
		let (c0p, range0) = getChar(range: srcrange, string: srcstr)
		if let c0 = c0p {
			if c0 == "0" {
				let (c1p, range1) = getChar(range: range0, string: srcstr)
				if let c1 = c1p {
					if c1 == "x" || c1 == "X" {
						hasprefix    = true
						skippedrange = range1
					}
				}
			}
		}

		if !hasprefix {
			let hexstr = srcstr.substring(with: srcrange)
			throw CNParseError.ParseError(mCurrentLine, "Hex integer value must be started by \"0x\" but \"\(hexstr)\" is given")
		}

		let (resstr, resrange) = getAnyTokenFromString(range: skippedrange, string: srcstr, matchingFunc: {
			(_ c: Character) -> Bool in
			return c.isHex()
		})
		if let value = UInt(resstr, radix: 16) {
			return (CNToken(type: .UIntToken(value), lineNo: mCurrentLine), resrange)
		} else {
			throw CNParseError.ParseError(mCurrentLine, "Hex integer value is expected but \"\(resstr)\" is given")
		}
	}

	private func getIdentifierTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) -> (CNToken, Range<String.Index>) {
		let (resstr, resrange) = getAnyTokenFromString(range: srcrange, string: srcstr, matchingFunc: {
			(_ c: Character) -> Bool in
			return c.isAlphaOrNum() || c == "_"
		})
		return (CNToken(type: .IdentifierToken(resstr), lineNo: mCurrentLine), resrange)
	}

	private func getStringTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) throws -> (CNToken, Range<String.Index>) {
		/* Check the source string is started by "\"" */
		var has1stquot = false
		let (c0p, range0) = getChar(range: srcrange, string: srcstr)
		if let c0 = c0p {
			if c0 == "\"" {
				has1stquot = true
			}
		}
		if !has1stquot {
			throw CNParseError.ParseError(mCurrentLine, "String value is expected but \"\(srcstr.substring(with: srcrange))\" is given")
		}

		var prevchar	: Character = " "
		var prevprevchar: Character = " "
		let (resstr, resrange) = getAnyTokenFromString(range: range0, string: srcstr, matchingFunc: {
			(_ c: Character) -> Bool in
			/* count newlines */
			if c == "\n" {
				mCurrentLine += 1
			}
			/* keep current previous characters */
			let pchar    = prevchar
			let ppchar   = prevprevchar
			/* keep next previous characters for next call */
			prevprevchar = prevchar
			prevchar     = c
			let isquot: Bool
			if ppchar == "\\" && pchar == "\\" {
				isquot = c == "\""
			} else {
				isquot = pchar != "\\" && c == "\""
			}
			return !isquot
		})

		let (clp, rangel) = getChar(range: resrange, string: srcstr)
		if let cl = clp {
			if cl == "\"" {
				return (CNToken(type: .StringToken(resstr), lineNo: mCurrentLine), rangel)
			}
		}
		throw CNParseError.ParseError(mCurrentLine, "String value is not ended by \" but \"\(srcstr.substring(with: srcrange))\" is given")
	}

	private func getTextTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) throws -> (CNToken, Range<String.Index>)
	{
		/* Check the source string is started by "%{" */
		var hasheader = false
		var range0: Range<String.Index> = srcrange
		let (c0p, range0a) = getChar(range: srcrange, string: srcstr)
		if let c0 = c0p {
			let (c1p, range0b) = getChar(range: range0a, string: srcstr)
			if let c1 = c1p {
				hasheader = (c0 == "%") && (c1 == "{")
				range0    = range0b
			}
		}
		if !hasheader {
			throw CNParseError.ParseError(mCurrentLine, "String value is expected but \"\(srcstr.substring(with: srcrange))\" is given")
		}

		var prevchar	: Character = " "
		var isinstr	: Bool = false
		let (resstr, resrange) = getAnyTokenFromString(range: range0, string: srcstr, matchingFunc: {
			(_ c: Character) -> Bool in

			var docont = true

			/* count newlines */
			if c == "\n" {
				mCurrentLine += 1
			}
			if isinstr {
				if prevchar != "\\" && c == "\"" {
					isinstr = false
				}
			} else {
				if prevchar == "}" && c == "%" {
					docont = false
				} else if prevchar != "\\" && c == "\"" {
					isinstr = true
				}
			}
			prevchar = c
			return docont
		})

		let (clp, rangel) = getChar(range: resrange, string: srcstr)
		if let cl = clp {
			if cl == "%" {
				/* Delete last "}" */
				let sidx = resstr.startIndex
				let eidx = resstr.index(before: resstr.endIndex)
				let substr = resstr.substring(with: sidx..<eidx)
				return (CNToken(type: .StringToken(substr), lineNo: mCurrentLine), rangel)
			}
		}
		throw CNParseError.ParseError(mCurrentLine, "Text value is not ended by }% but \"\(srcstr.substring(with: srcrange))\" is given")
	}

	private func getAnyTokenFromString(range srcrange: Range<String.Index>, string srcstr: String,
					   matchingFunc matchfunc: (_ c:Character) -> Bool) -> (String, Range<String.Index>)
	{
		var result: String = ""
		var idx  = srcrange.lowerBound
		let eidx = srcrange.upperBound
		while idx < eidx {
			let c = srcstr[idx]
			if matchfunc(c) {
				result.append(c)
			} else {
				break
			}
			idx = srcstr.index(after: idx)
		}
		return (result, idx..<eidx)
	}
}

