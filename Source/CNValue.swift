/*
 * @file	CNValue.swift
 * @brief	Define CNValue class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNValue: Hashable, CustomStringConvertible
{
	case BooleanValue(value: Bool)
	case IntValue(value: Int)
	case UIntValue(value: UInt)
	case FloatValue(value: CGFloat)
	case DoubleValue(value: Double)
	case StringValue(value: String)
	case ArrayValue(value: Array<CNValue>)
	case SetValue(value: Set<CNValue>)
	case DictionaryValue(value: Dictionary<String, CNValue>)

	public var booleanValue: Bool {
		switch self {
		case .BooleanValue(let v):
			return v
		default:
			fatalError("Does not have booleanValue")
		}
	}

	public var intValue: Int {
		switch self {
		case .IntValue(let v):
			return v
		default:
			fatalError("Does not have intValue")
		}
	}

	public var uIntValue: UInt {
		switch self {
		case .UIntValue(let v):
			return v
		default:
			fatalError("Does not have uIntValue")
		}
	}

	public var floatValue: CGFloat {
		switch self {
		case .FloatValue(let v):
			return v
		default:
			fatalError("Does not have floatValue")
		}
	}

	public var doubleValue: Double {
		switch self {
		case .DoubleValue(let v):
			return v
		default:
			fatalError("Does not have doubleValue")
		}
	}

	public var stringValue: String {
		switch self {
		case .StringValue(let v):
			return v
		default:
			fatalError("Does not have stringValue")
		}
	}

	public var arrayValue: Array<CNValue> {
		switch self {
		case .ArrayValue(let v):
			return v
		default:
			fatalError("Does not have arrayValue")
		}
	}

	public var setValue: Set<CNValue> {
		switch self {
		case .SetValue(let v):
			return v
		default:
			fatalError("Does not have setValue")
		}
	}

	public var dictionaryValue: Dictionary<String, CNValue> {
		switch self {
		case .DictionaryValue(let v):
			return v
		default:
			fatalError("Does not have dictionaryValue")
		}
	}

	/// String to describe the context
	public var description: String {
		let desc: String
		switch self {
		case .BooleanValue(let value):
			desc = "\(value)"
		case .IntValue(let value):
			desc = "\(value)"
		case .UIntValue(let value):
			desc = "\(value)"
		case .FloatValue(let value):
			desc = "\(value)"
		case .DoubleValue(let value):
			desc = "\(value)"
		case .StringValue(let value):
			desc = "\"\(value)\""
		case .ArrayValue(let value):
			var result = "["
			var is1st  = true
			for val in value {
				if !is1st {
					result += ", "
				}
				result += val.description
				is1st = false
			}
			desc = result + "]"
		case .SetValue(let value):
			var result = "["
			var is1st  = true
			for val in value {
				if !is1st {
					result += ", "
				}
				result += val.description
				is1st = false
			}
			desc = result + "]"
		case .DictionaryValue(let value):
			var result = "["
			var is1st  = true
			for (key, val) in value {
				if !is1st {
					result += ", "
				}
				result += key + ":" + val.description
				is1st = false
			}
			desc = result + "]"
		}
		return desc
	}

	public var typeDescription: String {
		let desc: String
		switch self {
		case .BooleanValue(_):		desc = "Bool"
		case .IntValue(_):		desc = "Int"
		case .UIntValue(_):		desc = "UInt"
		case .FloatValue(_):		desc = "Float"
		case .DoubleValue(_):		desc = "Double"
		case .StringValue(_):		desc = "String"
		case .ArrayValue(_):		desc = "Array"
		case .SetValue(_):		desc = "Set"
		case .DictionaryValue(_):	desc = "Dictionary"
		}
		return desc
	}

	public var hashValue: Int {
		var result: Int
		switch self {
		case .BooleanValue(let value):
			if value {
				result = 0x01000000
			} else {
				result = 0x01000001
			}
		case .IntValue(let value):
			result = Int(0x02000000) | Int(value)
		case .UIntValue(let value):
			result = Int(0x03000000) | Int(value)
		case .FloatValue(let value):
			result = Int(0x04000000) | Int(value * 100.0)
		case .DoubleValue(let value):
			result = Int(0x05000000) | Int(value * 100.0)
		case .StringValue(let value):
			result = Int(0x06000000) | value.hash
		case .ArrayValue(let value):
			result = Int(0x07000000) | value.count
		case .SetValue(let value):
			result = Int(0x08000000) | value.count
		case .DictionaryValue(let value):
			result = Int(0x09000000) | value.count
		}
		return result
	}

	public static func == (lhs: CNValue, rhs: CNValue) -> Bool {
		let result: Bool
		switch lhs {
		case .BooleanValue(let lval):
			switch rhs {
			case .BooleanValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .IntValue(let lval):
			switch rhs {
			case .IntValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .UIntValue(let lval):
			switch rhs {
			case .UIntValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .FloatValue(let lval):
			switch rhs {
			case .FloatValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .DoubleValue(let lval):
			switch rhs {
			case .DoubleValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .StringValue(let lval):
			switch rhs {
			case .StringValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .ArrayValue(let lval):
			switch rhs {
			case .ArrayValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .SetValue(let lval):
			switch rhs {
			case .SetValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		case .DictionaryValue(let lval):
			switch rhs {
			case .DictionaryValue(let rval):
				result = (lval == rval)
			default:
				result = false
			}
		}
		return result
	}
}

public func CNHasSameValueType(_ v0: CNValue, _ v1: CNValue) -> Bool
{
	let result: Bool
	switch v0 {
	case .BooleanValue(_):
		switch v1 {
		case .BooleanValue(_):
			result = true
		default:
			result = false
		}
	case .IntValue(_):
		switch v1 {
		case .IntValue(_):
			result = true
		default:
			result = false
		}
	case .UIntValue(_):
		switch v1 {
		case .UIntValue(_):
			result = true
		default:
			result = false
		}
	case .FloatValue(_):
		switch v1 {
		case .FloatValue(_):
			result = true
		default:
			result = false
		}
	case .DoubleValue(_):
		switch v1 {
		case .DoubleValue(_):
			result = true
		default:
			result = false
		}
	case .StringValue(_):
		switch v1 {
		case .StringValue(_):
			result = true
		default:
			result = false
		}
	case .ArrayValue(let a0):
		switch v1 {
		case .ArrayValue(let a1):
			if a0.count > 0 && a1.count > 0 {
				result = CNHasSameValueType(a0[0], a1[0])
			} else {
				result = true
			}
		default:
			result = false
		}
	case .SetValue(let a0):
		switch v1 {
		case .SetValue(let a1):
			if let e0 = a0.first, let e1 = a1.first {
				result = CNHasSameValueType(e0, e1)
			} else {
				result = true
			}
		default:
			result = false
		}
	case .DictionaryValue(let a0):
		switch v1 {
		case .DictionaryValue(let a1):
			if let e0 = a0.first, let e1 = a1.first {
				result = CNHasSameValueType(e0.value, e1.value)
			} else {
				result = true
			}
		default:
			result = false
		}
	}
	return result
}

