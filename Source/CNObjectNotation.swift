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
		case ArrayValue(value: Array<CNObjectNotation>)
		case SetValue(value: Array<CNObjectNotation>)
		case ClassValue(name: String?, value: Array<CNObjectNotation>)
		case ScriptValue(value: String)
	}

	private var mIdentifier	: String
	private var mValue	: ValueObject

	public var identifier	: String	{ return mIdentifier	}
	public var value	: ValueObject	{ return mValue		}

	public init(identifier ident: String, value v: ValueObject){
		mIdentifier	= ident
		mValue		= v
	}

	public init(identifier ident: String, primitiveValue value: CNValue){
		mIdentifier	= ident
		mValue		= ValueObject.PrimitiveValue(value: value)
	}

	public init(identifier ident: String, arrayValue value: Array<CNObjectNotation>){
		mIdentifier	= ident
		mValue		= ValueObject.ArrayValue(value: value)
	}

	public init(identifier ident: String, setValue value: Array<CNObjectNotation>){
		mIdentifier	= ident
		mValue		= ValueObject.SetValue(value: value)
	}

	public init(identifier ident: String, className name: String?, properties prop: Array<CNObjectNotation>){
		mIdentifier	= ident
		mValue		= ValueObject.ClassValue(name: name, value: prop)
	}

	public init(identifier ident: String, script scr: String){
		mIdentifier	= ident
		mValue		= ValueObject.ScriptValue(value: scr)
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
