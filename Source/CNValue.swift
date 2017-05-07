/*
 * @file	CNValue.swift
 * @brief	Define CNValue class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum CNValueType {
	case BooleanType
	case IntType
	case UIntType
	case FloatType
	case DoubleType
	case StringType
	case ArrayType
	case SetType
	case DictionaryType

	public var description: String {
		get {
			var result: String
			switch self {
			case .BooleanType:	result = "Bool"
			case .IntType:		result = "Int"
			case .UIntType:		result = "UInt"
			case .FloatType:	result = "Float"
			case .DoubleType:	result = "Double"
			case .StringType:	result = "String"
			case .ArrayType:	result = "Array"
			case .SetType:		result = "Set"
			case .DictionaryType:	result = "Dictionary"
			}
			return result
		}
	}
}

private enum CNValueData {
	case BooleanValue(value: Bool)
	case IntValue(value: Int)
	case UIntValue(value: UInt)
	case FloatValue(value: Float)
	case DoubleValue(value: Double)
	case StringValue(value: String)
	case ArrayValue(value: Array<CNValue>)
	case SetValue(value: Set<CNValue>)
	case DictionaryValue(value: Dictionary<String, CNValue>)

	public var booleanValue: Bool? {
		get {
			switch self {
			case .BooleanValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var intValue: Int? {
		get {
			switch self {
			case .IntValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var uIntValue: UInt? {
		get {
			switch self {
			case .UIntValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var floatValue: Float? {
		get {
			switch self {
			case .FloatValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var doubleValue: Double? {
		get {
			switch self {
			case .DoubleValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var stringValue: String? {
		get {
			switch self {
			case .StringValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var arrayValue: Array<CNValue>? {
		get {
			switch self {
			case .ArrayValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var setValue: Set<CNValue>? {
		get {
			switch self {
			case .SetValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var dictionaryValue: Dictionary<String, CNValue>? {
		get {
			switch self {
			case .DictionaryValue(let val):	return val
			default:			return nil
			}
		}
	}

	public var description: String {
		get {
			var result: String
			switch self {
			case .BooleanValue(let val):	result = "\(val)"
			case .IntValue(let val):	result = "\(val)"
			case .UIntValue(let val):	result = "\(val)"
			case .FloatValue(let val):	result = "\(val)"
			case .DoubleValue(let val):	result = "\(val)"
			case .StringValue(let val):	result = "\"" + val + "\""
			case .ArrayValue(let arr):
				var str:String = "["
				var is1st      = true
				for elm in arr {
					if !is1st {
						str = str + ", "
					} else {
						is1st = false
					}
					str = str + elm.description
				}
				result = str + "]"
			case .SetValue(let set):
				var str:String = "["
				var is1st      = true
				for elm in set {
					if !is1st {
						str = str + ", "
					} else {
						is1st = false
					}
					str = str + elm.description
				}
				result = str + "]"
			case .DictionaryValue(let dict):
				var str:String = "["
				var is1st      = true
				for (key, elm) in dict {
					if !is1st {
						str = str + ", "
					} else {
						is1st = false
					}
					str = str + key + ":" + elm.description
				}
				result = str + "]"
			}
			return result
		}
	}
}

public class CNValue: NSObject
{
	private var mType: CNValueType
	private var mData: CNValueData

	public var type: CNValueType {
		get { return mType }
	}

	public init(booleanValue val: Bool){
		mType = .BooleanType
		mData = .BooleanValue(value: val)
	}

	public init(intValue val: Int){
		mType = .IntType
		mData = .IntValue(value: val)
	}

	public init(uIntValue val: UInt){
		mType = .UIntType
		mData = .UIntValue(value: val)
	}

	public init(floatValue val: Float){
		mType = .FloatType
		mData = .FloatValue(value: val)
	}

	public init(doubleValue val: Double){
		mType = .DoubleType
		mData = .DoubleValue(value: val)
	}

	public init(stringValue val: String){
		mType = .StringType
		mData = .StringValue(value: val)
	}

	public init(arrayValue val: Array<CNValue>){
		mType = .ArrayType
		mData = .ArrayValue(value: val)
	}

	public init(setValue val: Set<CNValue>){
		mType = .SetType
		mData = .SetValue(value: val)
	}

	public init(dictionaryValue val: Dictionary<String, CNValue>){
		mType = .DictionaryType
		mData = .DictionaryValue(value: val)
	}

	public var booleanValue: Bool?		{ return mData.booleanValue }
	public var intValue: Int?		{ return mData.intValue }
	public var uIntValue: UInt?		{ return mData.uIntValue }
	public var floatValue: Float?		{ return mData.floatValue }
	public var doubleValue: Double?		{ return mData.doubleValue }
	public var stringValue: String?		{ return mData.stringValue }
	public var arrayValue: Array<CNValue>?	{ return mData.arrayValue }
	public var setValue: Set<CNValue>?	{ return mData.setValue }
	public var dictionaryValue: Dictionary<String, CNValue>?
						{ return mData.dictionaryValue }

	public override var description: String {
		get { return mData.description }
	}

	public var typeDescription: String {
		get { return mType.description }
	}

	public func cast(to dsttype: CNValueType) -> CNValue? {
		switch dsttype {
		case .BooleanType:
			switch type {
			case .BooleanType:
				return self
			default:
				return nil
			}
		case .IntType:
			switch type {
			case .IntType:
				return self
			case .UIntType:
				return CNValue(intValue: Int(uIntValue!))
			case .FloatType:
				return CNValue(intValue: Int(floatValue!))
			case .DoubleType:
				return CNValue(intValue: Int(doubleValue!))
			default:
				return nil
			}
		case .UIntType:
			switch type {
			case .IntType:
				return CNValue(uIntValue: UInt(intValue!))
			case .UIntType:
				return self
			case .FloatType:
				return CNValue(uIntValue: UInt(floatValue!))
			case .DoubleType:
				return CNValue(uIntValue: UInt(doubleValue!))
			default:
				return nil
			}
		case .FloatType:
			switch type {
			case .IntType:
				return CNValue(floatValue: Float(intValue!))
			case .UIntType:
				return CNValue(floatValue: Float(uIntValue!))
			case .FloatType:
				return self
			case .DoubleType:
				return CNValue(floatValue: Float(doubleValue!))
			default:
				return nil
			}
		case .DoubleType:
			switch type {
			case .IntType:
				return CNValue(doubleValue: Double(intValue!))
			case .UIntType:
				return CNValue(doubleValue: Double(uIntValue!))
			case .FloatType:
				return CNValue(doubleValue: Double(floatValue!))
			case .DoubleType:
				return self
			default:
				return nil
			}
		case .StringType:
			return CNValue(stringValue: description)
		case .ArrayType:
			switch type {
			case .ArrayType:
				return self
			case .SetType:
				var arr: Array<CNValue> = []
				for elm in setValue! {
					arr.append(elm)
				}
				return CNValue(arrayValue: arr)
			default:
				return nil
			}
		case .SetType:
			switch type {
			case .ArrayType:
				var set: Set<CNValue> = []
				for elm in arrayValue! {
					set.insert(elm)
				}
				return CNValue(setValue: set)
			case .SetType:
				return self
			default:
				return nil
			}
		case .DictionaryType:
			switch type {
			case .DictionaryType:
				return self
			default:
				return nil
			}
		}
	}
}


