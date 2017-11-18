/*
 * @file	CNObjectCoder.swift
 * @brief	Define CNObjectCoder class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

private enum CNReservedWordId:Int {
	case OutputConnection
	case InputConnection

	public var description: String {
		get {
			var result: String
			switch self {
			case .OutputConnection:
				result = ">>"
			case .InputConnection:
				result = "<<"
			}
			return result
		}
	}

	public static func decode(firstChar fchar: Character, secondChar schar : Character) -> CNReservedWordId? {
		if fchar == ">" && schar == ">" {
			return .OutputConnection
		} else if fchar == "<" && schar == "<" {
			return .InputConnection
		} else {
			return nil
		}
	}

	public static func encode(reservedWordId rid: Int) -> String {
		var result: String
		if rid == CNReservedWordId.InputConnection.rawValue {
			let rword = CNReservedWordId.InputConnection
			result = rword.description
		} else if rid == CNReservedWordId.OutputConnection.rawValue {
			let rword = CNReservedWordId.OutputConnection
			result = rword.description
		} else {
			fatalError("Invalid raw value for enum")
		}
		return result
	}
}

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
		let typename = src.typeName()
		let header = src.identifier + ": " + typename + " "
		let value  = encodeValue(indent: idt, notation: src)
		return indent2string(indent: idt) + header + value ;
	}

	private func encodeValue(indent idt: Int, notation src: CNObjectNotation) -> String {
		var result: String
		switch src.value {
		case .PrimitiveValue(let v):
			result = v.description
		case .EventMethodValue(_, let script):
			result  = "%{\n"
			result += script + "\n"
			result += indent2string(indent: idt) + "%}"
		case .ListenerMethodValue(_, let exps, let script):
			result = ""
			if exps.count > 0 {
				result += "["
				var is1st = true
				for exp in exps {
					if is1st {
						is1st = false
					} else {
						result += ", "
					}
					result += exp.description
				}
				result += "] "
			}
			result += "%{\n"
			result += script + "\n"
			result += indent2string(indent: idt) + "%}"
		case .ClassValue(_, let children):
			result = "{\n"
			for child in children {
				result += encode(indent: idt+1, notation: child) + "\n"
			}
			result += indent2string(indent: idt) + "}"
		case .ConnectionValue(let type, let pathexp):
			switch type {
			case .InputConnection:  result = "<<"
			case .OutputConnection: result = ">>"
			}
			result += pathexp.description
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
			let (notation, _) = try decode(tokens: mtokens, index: 0)
			return notation
		case .TokenizeError(_, _), .ParseError(_, _):
			throw tkerr
		}
	}

	private func mergeTokens(tokens src: Array<CNToken>) -> Array<CNToken> {
		var result: 	Array<CNToken>	= []

		var idx   = 0
		let count = src.count
		while idx < count {
			switch src[idx].type {
			case .ReservedWordToken(_):
				result.append(src[idx])
				idx += 1
			case .SymbolToken(let c0):
				var didadded = false
				let idx1 = idx + 1 ;
				if idx1 < count {
					switch src[idx1].type {
					case .SymbolToken(let c1):
						if let rid = CNReservedWordId.decode(firstChar: c0, secondChar: c1) {
							let rtoken = CNToken(type: .ReservedWordToken(rid.rawValue), lineNo: src[idx].lineNo)
							result.append(rtoken)
							idx += 2
							didadded = true
						}
					default:
						break
					}
				}
				if !didadded {
					result.append(src[idx])
					idx += 1
				}
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

	public func decode(tokens src: Array<CNToken>, index idx: Int) throws -> (CNObjectNotation, Int)
	{
		/* Get identifier */
		let (identp, idx0) = getIdentifier(tokens: src, index: idx)
		if identp == nil {
			let str = src[idx].toString()
			throw CNParseError.ParseError(src[idx], "Identifier is required but \"\(str)\" is given")
		}
		/* Get ":" */
		let (hascomma, idx1) = hasSymbol(tokens: src, index: idx0, symbol: ":")
		if !hascomma {
			throw CNParseError.ParseError(src[idx], "\":\" is required after identifier \(identp!)")
		}
		/* Get type name */
		let (typenamep, idx2) = getIdentifier(tokens: src, index: idx1)
		var typename: String
		if let t = typenamep {
			typename = t
		} else {
			throw CNParseError.ParseError(src[idx], "Type name is expected")
		}
		if !(idx2 < src.count) {
			throw CNParseError.ParseError(src[idx], "Object value is not declared")
		}

		/* Get value */
		var objvalue3	: CNObjectNotation.ValueObject
		var idx3	: Int
		switch src[idx2].type {
		case .ReservedWordToken(let rid):
			idx3 = idx2 + 1
			if idx3 < src.count {
				switch CNReservedWordId(rawValue: rid)! {
				case .InputConnection:
					let (pathexp, newidx)  = try getPathExpression(tokens: src, index: idx3)
					objvalue3 = CNObjectNotation.ValueObject.ConnectionValue(type: .InputConnection, pathExpression: pathexp)
					idx3 = newidx
				case .OutputConnection:
					let (pathexp, newidx)  = try getPathExpression(tokens: src, index: idx3)
					objvalue3 = CNObjectNotation.ValueObject.ConnectionValue(type: .OutputConnection, pathExpression: pathexp)
					idx3 = newidx
				}
			} else {
				throw CNParseError.ParseError(src[idx2], "Pass expression is required")
			}
		case .SymbolToken(let sym):
			switch sym {
			case "{":
				let (objs, newidx) = try decodeClassValue(tokens: src, index: idx2)
				objvalue3 = CNObjectNotation.ValueObject.ClassValue(name: typename, value: objs)
				idx3      = newidx
			case "[":
				let type = try decodeType(tokens: src, index: idx, typeName: typename)
				let (exps, script, newidx) = try decodeMethodValue(tokens: src, index: idx2)
				if exps.count > 0 {
					objvalue3 = CNObjectNotation.ValueObject.ListenerMethodValue(type: type, pathExpressions: exps, script: script)
				} else {
					objvalue3 = CNObjectNotation.ValueObject.EventMethodValue(type: type, script: script)
				}
				idx3      = newidx
			default:
				throw CNParseError.ParseError(src[idx], "Unexpected symbol \"\(sym)\"")
			}
		case .IdentifierToken(let ident):
			throw CNParseError.ParseError(src[idx], "Unexpected identifier \"\(ident)\"")
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
		case .TextToken(_):
			let type = try decodeType(tokens: src, index: idx, typeName: typename)
			let (exps, script, newidx) = try decodeMethodValue(tokens: src, index: idx2)
			if exps.count > 0 {
				objvalue3 = CNObjectNotation.ValueObject.ListenerMethodValue(type: type, pathExpressions: exps, script: script)
			} else {
				objvalue3 = CNObjectNotation.ValueObject.EventMethodValue(type: type, script: script)
			}
			idx3      = newidx
		}

		/* check type matching */
		var objvalue4	: CNObjectNotation.ValueObject
		let idx4	: Int = idx3
		objvalue4 = try cast(source: objvalue3, to: typename, lineNo: src[idx2].lineNo)
		
		/* allocate object notation */
		return (CNObjectNotation(identifier: identp!, value: objvalue4, lineNo: src[idx].lineNo), idx4)
	}

	public func decodeClassValue(tokens src: Array<CNToken>, index idx: Int) throws -> (Array<CNObjectNotation>, Int) {
		var result: Array<CNObjectNotation> = []
		var curidx = idx

		/* get "{" */
		let (haslp, idx1) = hasSymbol(tokens: src, index: idx, symbol: "{")
		if !haslp {
			throw CNParseError.ParseError(src[idx], "\"{\" is required")
		}
		curidx = idx1

		/* get objects */
		let count   = src.count
		while curidx < count {
			let (hasrp, _) = hasSymbol(tokens: src, index: curidx, symbol: "}")
			if hasrp {
				break
			}
			/* get object */
			let (newobj, idx2) = try decode(tokens: src, index: curidx)
			result.append(newobj)
			curidx   = idx2
		}
		/* get "}" */
		let (hasrp, idx3) = hasSymbol(tokens: src, index: curidx, symbol: "}")
		if haslp && !hasrp {
			throw CNParseError.ParseError(src[idx], "\"}\" is required")
		}
		curidx = idx3
		return (result, curidx)
	}

	public func decodeMethodValue(tokens src: Array<CNToken>, index idx: Int) throws -> (Array<CNPathExpression>, String, Int) {
		/* get "[" */
		var pathexps : Array<CNPathExpression> = []
		var curidx = idx
		let (haslp0, idx0) = hasSymbol(tokens: src, index: curidx, symbol: "[")
		if haslp0 {
			curidx = idx0
			var is1st  = true
			while curidx < src.count {
				let (hasrp2, idx2) = hasSymbol(tokens: src, index: curidx, symbol: "]")
				if hasrp2 {
					curidx = idx2
					break
				} else {
					/* get "," */
					if is1st {
						is1st = false
					} else {
						let (hascm, idx3) = hasSymbol(tokens: src, index: curidx, symbol: ",")
						if hascm {
							curidx = idx3
						} else {
							throw CNParseError.ParseError(src[curidx], "\",\" is required")
						}
					}
					/* get path expression */
					let (exp, idx4) = try getPathExpression(tokens: src, index: curidx)
					pathexps.append(exp)
					curidx = idx4
				}
			}
		}
		/* Get text */
		if curidx < src.count {
			switch src[curidx].type {
			case .TextToken(let script):
				let newidx = curidx + 1
				return (pathexps, script, newidx)
			default:
				break
			}
		}
		throw CNParseError.ParseError(src[curidx], "script of method is required")
	}

	private func decodeType(tokens src: Array<CNToken>, index idx: Int, typeName name: String) throws -> CNValueType {
		if let type = CNValueType.decode(typeName: name) {
			return type
		} else {
			throw CNParseError.ParseError(src[idx], "Unknown data type: \"\(name)\"")
		}
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
		default:
			result = src
		}
		if let r = result {
			return r
		} else {
			throw CNParseError.TokenizeError(line, "Could not cast")
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

	private func getPathExpression(tokens src:Array<CNToken>, index idx: Int) throws -> (CNPathExpression, Int)
	{
		var elms: Array<String> = []
		var newidx = idx
		var is1st  = true
		var docont = true
		while docont {
			if !is1st {
				let (hascm, idx1) = hasSymbol(tokens: src, index: newidx, symbol: ".")
				if hascm {
					newidx = idx1
				} else {
					docont = false
					break
				}
			} else {
				is1st = false
			}
			let (identp, idx2) = getIdentifier(tokens: src, index: newidx)
			if let ident = identp {
				elms.append(ident)
				newidx = idx2
			} else {
				throw CNParseError.ParseError(src[newidx], "The identifier is required")
			}
		}
		return (CNPathExpression(pathElements: elms), newidx)
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
