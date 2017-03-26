/**
 * @file	CNToken.h
 * @brief	Define CNToken class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNToken {
	case SymbolToken(Character)
	case IdentifierToken(String)
	case UnsignedIntegerToken(UInt)
	case SignedIntegerToken(Int)
	case FloatToken(Double)
	case StringToken(String)

	public func description() -> String {
		let result: String
		switch self {
		case .SymbolToken(let val):
			result = "SymbolToken(\(val))"
		case .IdentifierToken(let val):
			result = "IdentifierToken(\(val))"
		case .UnsignedIntegerToken(let val):
			result = "UnsignedIntegerToken(\(val))"
		case .SignedIntegerToken(let val):
			result = "SignedIntegerToken(\(val))"
		case .FloatToken(let val):
			result = "FloatToken(\(val))"
		case .StringToken(let val):
			result = "StringToken(\(val))"
		}
		return result
	}
}

public enum CNTokenizeError: Error {
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

public func CNStringToToken(string srcstr: String) -> (CNTokenizeError, Array<CNToken>)
{
	let (err0, result0) = CNConvertStringToTokens(string: srcstr)
	switch err0 {
	case .NoError:
		let (err1, result1) = CNMergeTokens(source: result0)
		return (err1, result1)
	case .ParseError(_, _):
		return (err0, result0)
	}
}

private func CNConvertStringToTokens(string srcstr: String) -> (CNTokenizeError, Array<CNToken>)
{
	var srcrange = srcstr.startIndex ..< srcstr.endIndex
	var result : Array<CNToken> = []

	while !CNIsEndOfString(range: srcrange) {
		let skippedrange = CNSkipSpaces(range: srcrange, string: srcstr)
		if CNIsEndOfString(range: skippedrange) {
			break
		}
		let (error, token, newrange) = CNGetTokenFromString(range: skippedrange, string: srcstr)
		switch error {
		case .NoError:
			result.append(token)
			srcrange = newrange
		case .ParseError(_, _):
			return (error, [])
		}
	}

	return (CNTokenizeError.NoError, result)
}

private func CNGetTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) -> (CNTokenizeError, CNToken, Range<String.Index>)
{
	let range0 = CNSkipSpaces(range: srcrange, string: srcstr)

	let (c1p, range1) = CNGetChar(range: range0, string: srcstr)
	if let c1 = c1p {
		if c1 == "0" {
			let (c2p, _) = CNGetChar(range: range1, string: srcstr)
			if let c2 = c2p {
				switch c2 {
				case ".":
					return CNGetDigitTokenFromString(range: range0, string: srcstr)
				case "x", "X":
					return CNGetHexTokenFromString(range: range0, string: srcstr)
				default:
					let token = CNToken.UnsignedIntegerToken(0)
					return (.NoError, token, range1)
				}
			} else {
				let token = CNToken.UnsignedIntegerToken(0)
				return (.NoError, token, range1)
			}
		} else if c1.isDigit() {
			return CNGetDigitTokenFromString(range: range0, string: srcstr)
		} else if c1.isAlpha() || c1 == "_" {
			return CNGetIdentifierTokenFromString(range: range0, string: srcstr)
		} else if c1 == "\"" {
			return CNGetStringTokenFromString(range: range0, string: srcstr)
		} else {
			let token = CNToken.SymbolToken(c1)
			return (.NoError, token, range1)
		}
	} else {
		let token = CNToken.SymbolToken(" ")
		return (.NoError, token, range0)
	}
}

private func CNGetChar(range srcrange: Range<String.Index>, string srcstr: String) -> (Character?, Range<String.Index>)
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

private func CNIsEndOfString(range src: Range<String.Index>) -> Bool
{
	return !(src.lowerBound < src.upperBound)
}

private func CNSkipSpaces(range srcrange: Range<String.Index>, string srcstr: String) -> Range<String.Index>
{
	var idx  = srcrange.lowerBound
	let eidx = srcrange.upperBound
	while idx < eidx {
		if srcstr[idx].isSpace() {
			idx = srcstr.index(after: idx)
		} else {
			break
		}
	}
	return (idx..<eidx)
}

private func CNGetDigitTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) -> (CNTokenizeError, CNToken, Range<String.Index>)
{
	var hasperiod = false
	let (resstr, resrange) = CNGetAnyTokenFromString(range: srcrange, string: srcstr, matchingFunc: {
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
			return (.NoError, CNToken.FloatToken(value), resrange)
		} else {
			let err = CNTokenizeError.ParseError(1, "Double value is expected but \"\(resstr)\" is given")
			return (err, CNToken.FloatToken(0.0), resrange)
		}
	} else {
		if let value = UInt(resstr) {
			return (.NoError, CNToken.UnsignedIntegerToken(value), resrange)
		} else {
			let err = CNTokenizeError.ParseError(1, "Integer value is expected but \"\(resstr)\" is given")
			return (err, CNToken.UnsignedIntegerToken(0), resrange)
		}
	}
}

private func CNGetHexTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) -> (CNTokenizeError, CNToken, Range<String.Index>)
{
	/* Check the source string is started by "0x" */
	var hasprefix		: Bool = false
	var skippedrange	: Range<String.Index> = srcrange
	let (c0p, range0) = CNGetChar(range: srcrange, string: srcstr)
	if let c0 = c0p {
		if c0 == "0" {
			let (c1p, range1) = CNGetChar(range: range0, string: srcstr)
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
		let err = CNTokenizeError.ParseError(1, "Hex integer value must be started by \"0x\" but \"\(hexstr)\" is given")
		return (err, CNToken.UnsignedIntegerToken(0), srcrange)
	}

	let (resstr, resrange) = CNGetAnyTokenFromString(range: skippedrange, string: srcstr, matchingFunc: {
		(_ c: Character) -> Bool in
		return c.isHex()
	})
	if let value = UInt(resstr, radix: 16) {
		return (.NoError, CNToken.UnsignedIntegerToken(value), resrange)
	} else {
		let err = CNTokenizeError.ParseError(1, "Hex integer value is expected but \"\(resstr)\" is given")
		return (err, CNToken.UnsignedIntegerToken(0), resrange)
	}
}

private func CNGetIdentifierTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) -> (CNTokenizeError, CNToken, Range<String.Index>)
{
	let (resstr, resrange) = CNGetAnyTokenFromString(range: srcrange, string: srcstr, matchingFunc: {
		(_ c: Character) -> Bool in
		return c.isAlphaOrNum() || c == "_"
	})
	return (.NoError, CNToken.IdentifierToken(resstr), resrange)
}

private func CNGetStringTokenFromString(range srcrange: Range<String.Index>, string srcstr: String) -> (CNTokenizeError, CNToken, Range<String.Index>)
{
	/* Check the source string is started by "\"" */
	var has1stquot = false
	let (c0p, range0) = CNGetChar(range: srcrange, string: srcstr)
	if let c0 = c0p {
		if c0 == "\"" {
			has1stquot = true
		}
	}
	if !has1stquot {
		let err = CNTokenizeError.ParseError(1, "String value is expected but \"\(srcstr.substring(with: srcrange))\" is given")
		return (err, CNToken.StringToken(""), srcrange)
	}

	var prevchar	: Character = " "
	var prevprevchar: Character = " "
	let (resstr, resrange) = CNGetAnyTokenFromString(range: range0, string: srcstr, matchingFunc: {
		(_ c: Character) -> Bool in
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

	let (clp, rangel) = CNGetChar(range: resrange, string: srcstr)
	if let cl = clp {
		if cl == "\"" {
			return (.NoError, CNToken.StringToken(resstr), rangel)
		}
	}

	let err = CNTokenizeError.ParseError(1, "String value is not ended by \" but \"\(srcstr.substring(with: srcrange))\" is given")
	return (err, CNToken.StringToken(""), srcrange)
}

private func CNGetAnyTokenFromString(range srcrange: Range<String.Index>, string srcstr: String,
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

private func CNMergeTokens(source src: Array<CNToken>) -> (CNTokenizeError, Array<CNToken>)
{
	let reserror: CNTokenizeError = CNTokenizeError.NoError
	var resarray: Array<CNToken>  = []

	let srccount = src.count
	var i: Int   = 0
	while i < srccount {
		var donormalcopy = true

		switch src[i] {
		case .SymbolToken(let c):
			switch c {
			case "+", "-":
				let j = i + 1
				if j < srccount {
					switch src[j] {
					case .UnsignedIntegerToken(let v):
						let newtoken = CNNegateIntegerToken(sign: c, value: Int(v))
						resarray.append(newtoken)
						i += 2
						donormalcopy = false
					case .SignedIntegerToken(let v):
						let newtoken = CNNegateIntegerToken(sign: c, value: v)
						resarray.append(newtoken)
						i += 2
						donormalcopy = false
					case .FloatToken(let v):
						let newtoken = CNNegateFloatToken(sign: c, value: v)
						resarray.append(newtoken)
						i += 2
						donormalcopy = false
					default:
						break
					}
				}
			default:
				break
			}
		case .IdentifierToken(_):
			break
		case .UnsignedIntegerToken(_):
			break
		case .SignedIntegerToken(_):
			break
		case .FloatToken(_):
			break
		case .StringToken(let str0):
			var catstr   = str0
			var catcount = 0
			catloop: for j in i+1..<srccount {
				switch src[j] {
				case .StringToken(let val):
					catstr   = catstr + val
					catcount += 1
				default:
					break catloop
				}
			}
			if catcount > 0 {
				let cattoken = CNToken.StringToken(catstr)
				resarray.append(cattoken)
				i += catcount + 1
				donormalcopy = false
			}
		}
		if donormalcopy {
			resarray.append(src[i])
			i += 1
		}
	}

	return (reserror, resarray)
}

private func CNNegateIntegerToken(sign s:Character, value v: Int) -> CNToken
{
	let newval: Int
	switch s {
	case "-":	newval = -v
	default:	newval = v
	}
	return CNToken.SignedIntegerToken(newval)
}

private func CNNegateFloatToken(sign s:Character, value v: Double) -> CNToken
{
	let newval: Double
	switch s {
	case "-":	newval = -v
	default:	newval = v
	}
	return CNToken.FloatToken(newval)
}




