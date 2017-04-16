/*
 * @file	CNObjectNotation.swift
 * @brief	Define CNObjectNotation class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNObjectNotation
{
	public enum ValueType {
		case BoolType
		case IntType
		case UIntType
		case FloatType
		case StringType
		case ArrayType
		case SetType
		case ClassType(name: String?)
		case ScriptType

		public var description: String {
			var result: String
			switch self {
			case .BoolType:		result = "Bool"
			case .IntType:		result = "Int"
			case .UIntType:		result = "UInt"
			case .FloatType:	result = "Float"
			case .StringType:	result = "String"
			case .ArrayType:	result = "Array"
			case .SetType:		result = "Set"
			case .ClassType(let name):
				if let n = name {
					result = n
				} else {
					result = ""
				}
			case .ScriptType:	result = "Script"
			}
			return result
		}
	}

	public enum ValueObject {
		case PrimitiveValue(value: CNValue)
		case CollectionValue(value: Array<CNObjectNotation>)
		case ClassValue(value: Array<CNObjectNotation>)
		case ScriptValue(value: String)
	}

	private var mIdentifier	: String
	private var mType	: ValueType
	private var mValue	: ValueObject

	public init(identifier ident: String, type t: ValueType, value v: ValueObject){
		mIdentifier	= ident
		mType		= t
		mValue		= v
	}

	public init(identifier ident: String, boolValue v: Bool){
		mIdentifier	= ident
		mType		= .BoolType
		mValue		= ValueObject.PrimitiveValue(value: CNValue.BooleanValue(value: v))
	}

	public init(identifier ident: String, intValue v: Int){
		mIdentifier	= ident
		mType		= .IntType
		mValue		= ValueObject.PrimitiveValue(value: CNValue.IntValue(value: v))
	}

	public init(identifier ident: String, uIntValue v: UInt){
		mIdentifier	= ident
		mType		= .UIntType
		mValue		= ValueObject.PrimitiveValue(value: CNValue.UIntValue(value: v))
	}

	public init(identifier ident: String, floatValue v: Double){
		mIdentifier	= ident
		mType		= .FloatType
		mValue		= ValueObject.PrimitiveValue(value: CNValue.DoubleValue(value: v))
	}
	
	public init(identifier ident: String, stringValue v: String){
		mIdentifier	= ident
		mType		= .StringType
		mValue		= ValueObject.PrimitiveValue(value: CNValue.StringValue(value: v))
	}

	public init(identifier ident: String, arrayValue v:Array<CNObjectNotation>){
		mIdentifier	= ident
		mType		= .ArrayType
		mValue		= ValueObject.CollectionValue(value: v)
	}

	public init(identifier ident: String, setValue v:Array<CNObjectNotation>){
		mIdentifier	= ident
		mType		= .SetType
		mValue		= ValueObject.CollectionValue(value: v)
	}

	public init(identifier ident: String, scriptValue v: String){
		mIdentifier	= ident
		mType		= .ScriptType
		mValue		= ValueObject.ScriptValue(value: v)
	}

	public init(identifier ident: String, className name: String?, classValue v: Array<CNObjectNotation>){
		mIdentifier	= ident
		mType		= .ClassType(name: name)
		mValue		= ValueObject.ClassValue(value: v)
	}

	public var identifier	: String	{ return mIdentifier	}
	public var type		: ValueType	{ return mType		}
	public var value	: ValueObject	{ return mValue		}
}
