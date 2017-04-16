/*
 * @file	CNObjectCoder.swift
 * @brief	Define CNObjectCoder class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public func CNEncodeObjectNotation(notation src: CNObjectNotation) -> String
{
	let encoder = CNEncoder()
	return encoder.encode(indent: 0, notation: src)
}

public func CNDecodeObjectNotation(text src: String) -> (CNParseError, CNObjectNotation?)
{
	do {
		let decoder = CNDecoder()
		let result = try decoder.decode(text: src)
		return (.NoError, result)
	} catch let error {
		if let psrerr = error as? CNParseError {
			return (psrerr, nil)
		} else {
			fatalError("Unknown error")
		}
	}
}

private class CNEncoder
{
	public func encode(indent idt: Int, notation src: CNObjectNotation) -> String
	{
		let header = src.identifier + ": " + src.type.description + " "
		let value  = encodeValue(indent: idt, notation: src)
		return indent2string(indent: idt) + header + value ;
	}

	private func encodeValue(indent idt: Int, notation src: CNObjectNotation) -> String {
		var result: String
		switch src.value {
		case .PrimitiveValue(let v):
			result = v.description
		case .CollectionValue(let array):
			var is1st = true
			result = "["
			for v in array {
				if is1st {
					result += ", "
				}
				result += encodeValue(indent: 0, notation: v)
				is1st = false
			}
			result += "]"
		case .ScriptValue(let script):
			result = "{\n"
			result += script + "\n"
			result += indent2string(indent: idt) + "}"
		case .ClassValue(let children):
			result = "{\n"
			for child in children {
				result += encode(indent: idt+1, notation: child) + "\n"
			}
			result += indent2string(indent: idt) + "}"
		}
		return result
	}

	private func indent2string(indent idt: Int) -> String {
		var result = ""
		for _ in 0..<idt {
			result += "  "
		}
		return result ;
	}
}

private class CNDecoder
{
	static let DO_DEBUG = false

	public func decode(text src: String) throws -> CNObjectNotation
	{
		/* Tokenier */
		let (tkerr, tokens) = CNStringToToken(string: src)
		switch tkerr {
		case .NoError:
			/* Merge tokens */
			let mtokens = mergeTokens(tokens: tokens)
			if CNDecoder.DO_DEBUG {
				dumpTokens(tokens: mtokens)
			}
			/* Decode tokens */
			let (obj, _) = try decode(tokens: mtokens, index: 0)
			return obj
		case .ParseError(_, _):
			throw tkerr
		}
	}

	private func mergeTokens(tokens src: Array<CNToken>) -> Array<CNToken> {
		var result: Array<CNToken> = []

		var idx   = 0
		let count = src.count
		while idx < count {
			switch src[idx].type {
			case .SymbolToken(_):
				result.append(src[idx])
				idx += 1
			case .IdentifierToken(let ident):
				if ident == "true" {
					let newtoken = CNToken(type: .BoolToken(true), lineNo: src[idx].lineNo)
					result.append(newtoken)
				} else if ident == "false" {
					let newtoken = CNToken(type: .BoolToken(false), lineNo: src[idx].lineNo)
					result.append(newtoken)
				} else {
					result.append(src[idx])
				}
				idx += 1
			case .BoolToken(_), .IntToken(_), .UIntToken(_), .FloatToken(_), .TextToken(_):
				result.append(src[idx])
				idx += 1
			case .StringToken(let str):
				var newstr = str
				var newidx = idx + 1
				while newidx < count {
					if let nextstr = src[newidx].getString() {
						newstr += nextstr
						newidx += 1
					} else {
						break
					}
				}
				result.append(CNToken(type: .StringToken(newstr), lineNo: src[idx].lineNo))
				idx = newidx
			}
		}
		return result
	}

	private func decode(tokens src: Array<CNToken>, index idx: Int) throws -> (CNObjectNotation, Int) {
		var result : Array<CNObjectNotation> = []

		let (haslp, idx0) = hasSymbol(tokens: src, index: idx, symbol: "{")

		var idx1   : Int = idx0
		let count  : Int = src.count
		while idx1 < count {
			let (newobj, newidx) = try decodeObject(tokens: src, index: idx1)
			result.append(newobj)
			idx1 = newidx
			/* If rest token is only "}", breakout this loop */
			if idx1 + 1 >= count {
				let (hasrp, _) = hasSymbol(tokens: src, index: idx1, symbol: "}")
				if hasrp {
					break
				}
			}
		}

		var idx2 : Int
		if haslp {
			let (hasrp, newidx) = hasSymbol(tokens: src, index: idx1, symbol: "}")
			if !hasrp {
				throw CNParseError.ParseError(src[idx].lineNo, "Last \"}\" is required")
			}
			idx2 = newidx
		} else {
			idx2 = idx1
		}
		return (CNObjectNotation(identifier: "<root>", className: nil, classValue: result), idx2)
	}

	public func decodeObject(tokens src: Array<CNToken>, index idx: Int) throws -> (CNObjectNotation, Int)
	{
		/* Get identifier */
		let (identp, idx0) = getIdentifier(tokens: src, index: idx)
		if identp == nil {
			throw CNParseError.ParseError(src[idx].lineNo, "Identifier is required")
		}
		/* Get ":" */
		let (hascomma, idx1) = hasSymbol(tokens: src, index: idx0, symbol: ":")
		if !hascomma {
			throw CNParseError.ParseError(src[idx].lineNo, "\":\" is required after identifier \(identp!)")
		}
		/* Get type name */
		let (typep, idx2) = getIdentifier(tokens: src, index: idx1)
		if !(idx2 < src.count) {
			throw CNParseError.ParseError(src[idx].lineNo, "Object value is not declared")
		}

		/* Get value */
		var objtype3	: CNObjectNotation.ValueType
		var objvalue3	: CNObjectNotation.ValueObject
		var idx3	: Int
		switch src[idx2].type {
		case .SymbolToken(let sym):
			switch sym {
			case "[":
				let (objs, newidx) = try decodeCollectionValue(tokens: src, index: idx2)
				objtype3  = .ArrayType
				objvalue3 = CNObjectNotation.ValueObject.CollectionValue(value: objs)
				idx3      = newidx
			case "{":
				let (objs, newidx) = try decodeClassValue(tokens: src, index: idx2)
				objtype3  = .ClassType(name: typep)
				objvalue3 = CNObjectNotation.ValueObject.ClassValue(value: objs)
				idx3      = newidx
			default:
				throw CNParseError.ParseError(src[idx].lineNo, "Unexpected symbol \"\(sym)\"")
			}
		case .IdentifierToken(let ident):
			throw CNParseError.ParseError(src[idx].lineNo, "Unexpected identifier \"\(ident)\"")
		case .BoolToken(let value):
			objtype3  = .BoolType
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue.BooleanValue(value: value))
			idx3      = idx2 + 1
		case .IntToken(let value):
			objtype3  = .IntType
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue.IntValue(value: value))
			idx3      = idx2 + 1
		case .UIntToken(let value):
			objtype3  = .UIntType
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue.UIntValue(value: value))
			idx3      = idx2 + 1
		case .FloatToken(let value):
			objtype3  = .FloatType
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue.DoubleValue(value: value))
			idx3      = idx2 + 1
		case .StringToken(let value):
			objtype3  = .StringType
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue.StringValue(value: value))
			idx3      = idx2 + 1
		case .TextToken(let value):
			objtype3  = .ScriptType
			objvalue3 = CNObjectNotation.ValueObject.ScriptValue(value: value)
			idx3      = idx2 + 1
		}

		/* allocate object notation */
		return (CNObjectNotation(identifier: identp!, type: objtype3, value: objvalue3), idx3)
	}

	public func decodeCollectionValue(tokens src: Array<CNToken>, index idx: Int) throws -> (Array<CNObjectNotation>, Int) {
		var result: Array<CNObjectNotation> = []

		/* get "[" */
		let (haslp, idx0) = hasSymbol(tokens: src, index: idx, symbol: "[")
		if !haslp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"[\" is required")
		}
		/* get objects */
		var idx1   = idx0
		var is1st1 = true
		while idx1 < src.count {
			/* get comma */
			if !is1st1 {
				let (hascomm, newidx) = hasSymbol(tokens: src, index: idx1, symbol: ",")
				if !hascomm {
					throw CNParseError.ParseError(src[idx].lineNo, "\",\" is required")
				}
				idx1 = newidx
			}
			/* get object */
			let (newobj, newidx) = try decodeObject(tokens: src, index: idx1)
			result.append(newobj)
			idx1   = newidx
			is1st1 = false
		}
		/* get "]" */
		let (hasrp, idx2) = hasSymbol(tokens: src, index: idx1, symbol: "]")
		if !hasrp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"]\" is required")
		}
		return (result, idx2)
	}

	public func decodeClassValue(tokens src: Array<CNToken>, index idx: Int) throws -> (Array<CNObjectNotation>, Int) {
		var result: Array<CNObjectNotation> = []

		/* get "{" */
		let (haslp, idx0) = hasSymbol(tokens: src, index: idx, symbol: "[")
		if !haslp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"{\" is required")
		}
		/* get objects */
		var idx1   = idx0
		while idx1 < src.count {
			/* get object */
			let (newobj, newidx) = try decodeObject(tokens: src, index: idx1)
			result.append(newobj)
			idx1   = newidx
		}
		/* get "}" */
		let (hasrp, idx2) = hasSymbol(tokens: src, index: idx1, symbol: "}")
		if !hasrp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"}\" is required")
		}
		return (result, idx2)
	}

	private func getIdentifier(tokens src: Array<CNToken>, index idx: Int) -> (String?, Int) {
		let count = src.count
		if idx < count {
			if let ident = src[idx].getIdentifier() {
				return (ident, idx+1)
			}
		}
		return (nil, idx)
	}

	private func hasSymbol(tokens src:Array<CNToken>, index idx: Int, symbol sym: Character) -> (Bool, Int)
	{
		if idx < src.count {
			if src[idx].getSymbol() == sym {
				return (true, idx+1)
			}
		}
		return (false, idx)
	}

	private func dumpTokens(tokens tkns: Array<CNToken>){
		print("[Tokens]")
		for token in tkns {
			print(" \(token.description)")
		}
	}
}
