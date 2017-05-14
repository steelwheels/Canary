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

public func CNDecodeObjectNotation(text src: String) -> (CNParseError, Array<CNObjectNotation>)
{
	do {
		let decoder = CNDecoder()
		let result = try decoder.decode(text: src)
		return (.NoError, result)
	} catch let error {
		if let psrerr = error as? CNParseError {
			return (psrerr, [])
		} else {
			fatalError("Unknown error")
		}
	}
}

private class CNEncoder
{
	public func encode(indent idt: Int, notation src: CNObjectNotation) -> String
	{
		let typename: String
		if let name = src.typeName() {
			typename = name
		} else {
			typename = ""
		}
		let header = src.identifier + ": " + typename + " "
		let value  = encodeValue(indent: idt, notation: src)
		return indent2string(indent: idt) + header + value ;
	}

	private func encodeValue(indent idt: Int, notation src: CNObjectNotation) -> String {
		var result: String
		switch src.value {
		case .PrimitiveValue(let v):
			result = v.description
		case .ScriptValue(let script):
			result = "%{\n"
			result += script + "\n"
			result += indent2string(indent: idt) + "%}"
		case .ClassValue(_, let children):
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

	public func decode(text src: String) throws -> Array<CNObjectNotation>
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
			let (objs, _) = try decode(tokens: mtokens, index: 0)
			return objs
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
			case .BoolToken(_), .IntToken(_), .UIntToken(_), .DoubleToken(_), .TextToken(_):
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

	private func decode(tokens src: Array<CNToken>, index idx: Int) throws -> (Array<CNObjectNotation>, Int) {
		var result : Array<CNObjectNotation> = []

		let (haslp, idx0) = hasSymbol(tokens: src, index: idx, symbol: "{")

		var idx1   : Int = idx0
		let count  = src.count
		while idx1 < count {
			let (hasrp, _) = hasSymbol(tokens: src, index: idx1, symbol: "}")
			if hasrp {
				break
			}
			let (newobj, newidx) = try decodeObject(tokens: src, index: idx1)
			result.append(newobj)
			idx1 = newidx
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

		return (result, idx2)
	}

	public func decodeObject(tokens src: Array<CNToken>, index idx: Int) throws -> (CNObjectNotation, Int)
	{
		/* Get identifier */
		let (identp, idx0) = getIdentifier(tokens: src, index: idx)
		if identp == nil {
			let str = src[idx].toString()
			throw CNParseError.ParseError(src[idx].lineNo, "Identifier is required but \"\(str)\" is given")
		}
		/* Get ":" */
		let (hascomma, idx1) = hasSymbol(tokens: src, index: idx0, symbol: ":")
		if !hascomma {
			throw CNParseError.ParseError(src[idx].lineNo, "\":\" is required after identifier \(identp!)")
		}
		/* Get type name */
		let (typestrp, idx2) = getIdentifier(tokens: src, index: idx1)
		if !(idx2 < src.count) {
			throw CNParseError.ParseError(src[idx].lineNo, "Object value is not declared")
		}

		/* Get value */
		var objvalue3	: CNObjectNotation.ValueObject
		var idx3	: Int
		switch src[idx2].type {
		case .SymbolToken(let sym):
			switch sym {
			case "[":
				let (objs, newidx) = try decodeCollectionValue(tokens: src, index: idx2)
				objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue(arrayValue: objs))
				idx3      = newidx
			case "{":
				let (objs, newidx) = try decodeClassValue(tokens: src, index: idx2)
				if let typestr = typestrp {
					objvalue3 = CNObjectNotation.ValueObject.ClassValue(name: typestr, value: objs)
				} else {
					throw CNParseError.ParseError(src[idx].lineNo, "No class name")
				}
				idx3      = newidx
			default:
				throw CNParseError.ParseError(src[idx].lineNo, "Unexpected symbol \"\(sym)\"")
			}
		case .IdentifierToken(let ident):
			throw CNParseError.ParseError(src[idx].lineNo, "Unexpected identifier \"\(ident)\"")
		case .BoolToken(let value):
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue(booleanValue: value))
			idx3      = idx2 + 1
		case .IntToken(let value):
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue(intValue: value))
			idx3      = idx2 + 1
		case .UIntToken(let value):
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue(uIntValue: value))
			idx3      = idx2 + 1
		case .DoubleToken(let value):
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue(doubleValue: value))
			idx3      = idx2 + 1
		case .StringToken(let value):
			objvalue3 = CNObjectNotation.ValueObject.PrimitiveValue(value: CNValue(stringValue: value))
			idx3      = idx2 + 1
		case .TextToken(let value):
			objvalue3 = CNObjectNotation.ValueObject.ScriptValue(value: value)
			idx3      = idx2 + 1
		}

		/* check type matching */
		var objvalue4	: CNObjectNotation.ValueObject
		let idx4	: Int = idx3
		if let typestr = typestrp {
			objvalue4 = try cast(source: objvalue3, to: typestr, lineNo: src[idx2].lineNo)
		} else {
			objvalue4 = objvalue3
		}
		
		/* allocate object notation */
		return (CNObjectNotation(identifier: identp!, value: objvalue4, lineNo: src[idx].lineNo), idx4)
	}

	public func decodeCollectionValue(tokens src: Array<CNToken>, index idx: Int) throws -> (Array<CNValue>, Int) {
		var result: Array<CNValue> = []

		/* get "[" */
		let (haslp, idx0) = hasSymbol(tokens: src, index: idx, symbol: "[")
		if !haslp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"[\" is required")
		}
		/* get objects */
		var idx1    = idx0
		var is1st1  = true
		let count   = src.count
		while idx1 < count {
			/* check "]" */
			let (hasrp, _) = hasSymbol(tokens: src, index: idx1, symbol: "]")
			if hasrp {
				break
			}
			/* get comma */
			if !is1st1 {
				let (hascomm, newidx) = hasSymbol(tokens: src, index: idx1, symbol: ",")
				if !hascomm {
					let tkstr = src[idx1].toString()
					throw CNParseError.ParseError(src[idx].lineNo, "\",\" is required. But is \(tkstr) given.")
				}
				idx1 = newidx
			}
			/* value */
			var value: CNValue
			switch src[idx1].type {
			case .BoolToken(let v):
				value = CNValue(booleanValue: v)
			case .UIntToken(let v):
				value = CNValue(uIntValue: v)
			case .IntToken(let v):
				value = CNValue(intValue: v)
			case .DoubleToken(let v):
				value = CNValue(doubleValue: v)
			case .StringToken(let v):
				value = CNValue(stringValue: v)
			case .IdentifierToken(_), .SymbolToken(_), .TextToken(_):
				let strval = src[idx1].toString()
				throw CNParseError.ParseError(src[idx].lineNo,
				  "The primitive value is required, But \(strval)\" is given")
			}
			result.append(value)

			idx1   += 1
			is1st1  = false
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
		let (haslp, idx0) = hasSymbol(tokens: src, index: idx, symbol: "{")
		if !haslp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"{\" is required")
		}
		/* get objects */
		var idx1    = idx0
		let count   = src.count
		while idx1 < count {
			let (hasrp, _) = hasSymbol(tokens: src, index: idx1, symbol: "}")
			if hasrp {
				break
			}
			/* get object */
			let (newobj, newidx) = try decodeObject(tokens: src, index: idx1)
			result.append(newobj)
			idx1   = newidx
		}
		/* get "}" */
		let (hasrp, idx2) = hasSymbol(tokens: src, index: idx1, symbol: "}")
		if haslp && !hasrp {
			throw CNParseError.ParseError(src[idx].lineNo, "\"}\" is required")
		}
		return (result, idx2)
	}

	private func cast(source src: CNObjectNotation.ValueObject, to dststr: String, lineNo line: Int) throws -> (CNObjectNotation.ValueObject) {
		var result: CNObjectNotation.ValueObject? = nil
		switch dststr {
		case "Bool":
			switch src {
			case .PrimitiveValue(let srcval):
				if let dstval = srcval.cast(to: .BooleanType) {
					result = .PrimitiveValue(value: dstval)
				}
			default:
				break
			}
		case "Int":
			switch src {
			case .PrimitiveValue(let srcval):
				if let dstval = srcval.cast(to: .IntType) {
					result = .PrimitiveValue(value: dstval)
				}
			default:
				break
			}
		case "UInt":
			switch src {
			case .PrimitiveValue(let srcval):
				if let dstval = srcval.cast(to: .UIntType) {
					result = .PrimitiveValue(value: dstval)
				}
			default:
				break
			}
		case "Double":
			switch src {
			case .PrimitiveValue(let srcval):
				if let dstval = srcval.cast(to: .DoubleType) {
					result = .PrimitiveValue(value: dstval)
				}
			default:
				break
			}
		case "Array":
			switch src {
			case .PrimitiveValue(let srcval):
				if let dstval = srcval.cast(to: .ArrayType) {
					result = .PrimitiveValue(value: dstval)
				}
			default:
				break
			}
		case "Set":
			switch src {
			case .PrimitiveValue(let srcval):
				if let dstval = srcval.cast(to: .SetType) {
					result = .PrimitiveValue(value: dstval)
				}
			default:
				break
			}
		default:
			result = src
		}
		if let r = result {
			return r
		} else {
			throw CNParseError.ParseError(line, "Could not cast")
		}
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
