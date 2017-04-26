/*
 * @file	CNObjectNotation.swift
 * @brief	Define CNObjectNotation class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNObjectNotation
{
	public enum ValueObject {
		case PrimitiveValue(value: CNValue)
		case ArrayValue(value: Array<CNValue>)
		case SetValue(value: Array<CNValue>)
		case ClassValue(name: String, value: Array<CNObjectNotation>)
		case ScriptValue(value: String)
	}

	private var mIdentifier	: String
	private var mValue	: ValueObject
	private var mLineNo	: Int

	public var identifier	: String	{ return mIdentifier	}
	public var value	: ValueObject	{ return mValue		}
	public var lineNo	: Int		{ return mLineNo	}

	public init(identifier ident: String, value v: ValueObject, lineNo line: Int){
		mIdentifier	= ident
		mValue		= v
		mLineNo		= line
	}

	public init(identifier ident: String, primitiveValue value: CNValue, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.PrimitiveValue(value: value)
		mLineNo		= line
	}

	public init(identifier ident: String, arrayValue value: Array<CNValue>, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.ArrayValue(value: value)
		mLineNo		= line
	}

	public init(identifier ident: String, setValue value: Array<CNValue>, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.SetValue(value: value)
		mLineNo		= line
	}

	public init(identifier ident: String, className name: String, properties prop: Array<CNObjectNotation>, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.ClassValue(name: name, value: prop)
		mLineNo		= line
	}

	public init(identifier ident: String, script scr: String, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.ScriptValue(value: scr)
		mLineNo		= line
	}

	public func typeName() -> String? {
		var result: String?
		switch mValue {
		case .PrimitiveValue(let v):	result = v.typeDescription
		case .ArrayValue(_):		result = "Array"
		case .SetValue(_):		result = "Set"
		case .ClassValue(let name, _):	result = name
		case .ScriptValue(_):		result = nil
		}
		return result
	}
}
