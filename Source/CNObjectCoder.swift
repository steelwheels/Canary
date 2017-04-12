/*
 * @file	CNObjectCoder.swift
 * @brief	Define CNObjectCoder class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNObjectCoderError {
	case NoError
	case ParseError(message: String, lineNo: Int)
}

public func CNEncodeObjectNotation(notation src: CNObjectNotation) -> String
{
	let encoder = CNEncoder()
	return encoder.encode(indent: 0, notation: src)
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
		case .ScriptValue(let script):
			result = "{\n"
			result += script + "\n"
			result += indent2string(indent: idt) + "}"
		case .StructureValue(let array):
			result = "{\n"
			for child in array {
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

/*
public func CNEncodeObjectNotation(notation src: CNObjectNotation) -> String {
	let encoder = CNObjectEncoder()
	return encoder.encodeToString(indent: 0, notation: src)
}

private class CNObjectEncoder {
	public func encodeToString(indent idt: Int, notation src: CNObjectNotation) -> String {
		var result: String = indentString(indent: idt) + "("

		if let label = src.label {
			result += label + ": "
		}
		result += src.className + " "

		switch src.value {
		case .PrimitiveValue(let value):
			result += value.description
		case .ObjectValue(let objects):
			result += "\n"
			for object in objects {
				let objstr = encodeToString(indent: idt+1, notation: object)
				result += objstr
			}
			result += indentString(indent: idt)
		}

		result += ")\n"
		return result
	}

	private func indentString(indent idt: Int) -> String {
		var result = ""
		for _ in 0..<idt {
			result += " "
		}
		return result
	}
}

public enum CNObjectDecodeError: Error {
	case NoError
	case ParseError(Int, String)
}

public func CNDecodeObjectNotation(string srcstr: String) -> (CNObjectDecodeError, CNObjectNotation?)
{
	let encoder = CNObjectDecoder()
	return encoder.decode(string: srcstr)
}

private class CNObjectDecoder {
	public func decode(string srcstr: String) -> (CNObjectDecodeError, CNObjectNotation?) {
		let (err, tokens) = CNStringToToken(string: srcstr)
		switch err {
		case .NoError:
			if tokens.count > 0 {
				do {
					let object = try decodeFromTokens(startIndex: 0, tokens: tokens)
					return (.NoError, object)
				} catch let error {
					if let e = error as? CNObjectDecodeError {
						return (e, nil)
					} else {
						fatalError("Invalid error type")
					}
				}
			} else {
				return (CNObjectDecodeError.NoError, nil)
			}
		case .ParseError(let lineno, let message):
			return (CNObjectDecodeError.ParseError(lineno, message), nil)
		}
	}

	private func decodeFromTokens(startIndex sidx: Int, tokens srctokens: Array<CNToken>) throws -> CNObjectNotation {
		var label : String?	= nil
		var idx			= sidx

		/* Decode "(" */
		if let sym = srctokens[idx].getSymbol() {
			if sym == "(" {
				idx += 1
				try assertEndOfString(index: idx, tokens: srctokens, message: "Terminated by \"(\"")
			} else {
				throw parseError(index: idx, tokens: srctokens, message: "\"(\" is expected but \(sym) is given")
			}
		} else {
			throw parseError(index: idx, tokens: srctokens, message: "\"(\" is required")
		}

		/* Decode "label:" */
		label = getLabel(index: &idx, tokens: srctokens)
		try assertEndOfString(index: idx, tokens: srctokens, message: "Terminated by label")

		/* Get class */
		var result: CNObjectNotation
		if let typestr = srctokens[idx].getString() {
			idx += 1
			try assertEndOfString(index: idx, tokens: srctokens, message: "Primitive or collection value is required")

			switch typestr {
			case "Bool":	let value  = try decodeBoolValue(index: &idx, tokens: srctokens)
					result     = CNObjectNotation(label: label, primitiveValue: value)
			case "Int":	let value  = try decodeIntValue(index: &idx, tokens: srctokens)
					result     = CNObjectNotation(label: label, primitiveValue: value)
			case "UInt":	let value  = try decodeUIntValue(index: &idx, tokens: srctokens)
					result     = CNObjectNotation(label: label, primitiveValue: value)
			case "Double",
			     "Float":	let value  = try decodeDoubleValue(index: &idx, tokens: srctokens)
					result     = CNObjectNotation(label: label, primitiveValue: value)
			case "String":	let value  = try decodeStringValue(index: &idx, tokens: srctokens)
					result     = CNObjectNotation(label: label, primitiveValue: value)
			default:	let values = try decodeCollectionValues(index: &idx, tokens: srctokens)
					result	   = CNObjectNotation(label: label, className: typestr, objectValues: values)
			}
		} else {
			throw parseError(index: idx, tokens: srctokens, message: "Class name is required")
		}

		if let sym = srctokens[idx].getSymbol() {
			if sym == "(" {
				idx += 1
				return result
			}
		}
		throw parseError(index: idx, tokens: srctokens, message: "\")\" is required")
	}

	private func getLabel(index idx: inout Int, tokens srctokens: Array<CNToken>) -> String? {
		if idx+1 < srctokens.count {
			if let labstr = srctokens[idx].getString() {
				if let labsym = srctokens[idx+1].getSymbol() {
					if labsym == ":" {
						idx += 2
						return labstr
					}
				}
			}
		}
		return nil
	}

	private func decodeBoolValue(index idx: inout Int, tokens srctokens: Array<CNToken>) throws -> CNValue {
		if let ident = srctokens[idx].getIdentifier() {
			if ident == "true" {
				idx += 1
				return CNValue.BooleanValue(value: true)
			} else if ident == "false" {
				idx += 1
				return CNValue.BooleanValue(value: false)
			}
		}
		throw parseError(index: idx, tokens: srctokens, message: "Boolean value (true or false) is required")
	}

	private func decodeIntValue(index idx: inout Int, tokens srctokens: Array<CNToken>) throws -> CNValue {
		var isnegative = false
		if let sym = srctokens[idx].getSymbol() {
			switch sym {
			case "+": isnegative = false
			case "-": isnegative = true
			default:
				throw parseError(index: idx, tokens: srctokens, message: "Unexpected symbol \(sym)")
			}
			idx += 1
			try assertEndOfString(index: idx, tokens: srctokens, message: "Integer value is required")
		}
		if let value = srctokens[idx].getInteger() {
			if isnegative {
				idx += 1
				return CNValue.IntValue(value: -Int(value))
			} else {
				idx += 1
				return CNValue.UIntValue(value: value)
			}
		} else {
			throw parseError(index: idx, tokens: srctokens, message: "Integer value required")
		}
	}

	private func decodeUIntValue(index idx: inout Int, tokens srctokens: Array<CNToken>) throws -> CNValue {
		if let sym = srctokens[idx].getSymbol() {
			switch sym {
			case "+":
				break
			default:
				let lineno = srctokens[idx].lineNo
				throw CNObjectDecodeError.ParseError(lineno, "Unexpected symbol \(sym)")
			}
			idx += 1
			try assertEndOfString(index: idx, tokens: srctokens, message: "Integer value is required")
		}
		if let value = srctokens[idx].getInteger() {
			idx += 1
			return CNValue.UIntValue(value: value)
		} else {
			let lineno = srctokens[idx].lineNo
			throw CNObjectDecodeError.ParseError(lineno, "Integer value is required")
		}
	}

	private func decodeDoubleValue(index idx: inout Int, tokens srctokens: Array<CNToken>) throws -> CNValue {
		var isnegative = false
		if let sym = srctokens[idx].getSymbol() {
			switch sym {
			case "+": isnegative = false
			case "-": isnegative = true
			default:
				throw parseError(index: idx, tokens: srctokens, message: "Unexpected symbol \(sym)")
			}
			idx += 1
			try assertEndOfString(index: idx, tokens: srctokens, message: "Float value is required")
		}
		if let value = srctokens[idx].getFloat() {
			if isnegative {
				idx += 1
				return CNValue.DoubleValue(value: -value)
			} else {
				idx += 1
				return CNValue.DoubleValue(value: value)
			}
		} else {
			throw parseError(index: idx, tokens: srctokens, message: "Float value is required")
		}
	}

	private func decodeStringValue(index idx: inout Int, tokens srctokens: Array<CNToken>) throws-> CNValue {
		var hasres: Bool = false
		var resstr: String = ""
		while idx < srctokens.count {
			if let str = srctokens[idx].getString() {
				resstr += str
				idx += 1
				hasres = true
			} else {
				break
			}
		}
		if hasres {
			return CNValue.StringValue(value: resstr)
		} else {
			throw parseError(index: idx, tokens: srctokens, message: "String value is required")
		}
	}

	private func decodeCollectionValues(index idx: inout Int, tokens srctokens: Array<CNToken>) throws-> Array<CNObjectNotation> {
		var results: Array<CNObjectNotation> = []

		let count = srctokens.count
		while idx < count {
			if let sym = srctokens[idx].getSymbol() {
				if sym == "(" {
					let notation = try decodeFromTokens(startIndex: idx, tokens: srctokens)
					results.append(notation)
				} else {
					break
				}
			} else {
				break
			}
		}
		return results
	}

	private func parseError(index idx: Int, tokens srctokens: Array<CNToken>, message srcmsg: String) -> CNObjectDecodeError {
		let count = srctokens.count
		var lineno : Int
		if count > 0 {
			let nidx = min(idx, count-1)
			lineno = srctokens[nidx].lineNo
		} else {
			lineno = 1
		}
		return CNObjectDecodeError.ParseError(lineno, srcmsg)
	}

	private func assertEndOfString(index idx: Int, tokens srctokens: Array<CNToken>, message srcmsg: String) throws {
		if !(idx < srctokens.count){
			throw parseError(index: idx, tokens: srctokens, message: srcmsg)
		}
	}
}
*/
