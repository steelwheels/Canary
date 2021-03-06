/*
 * @file	CNObjectNotation.swift
 * @brief	Define CNObjectNotation class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNObjectNotation
{
	public enum ConnectionValueType {
		case InputConnection
		case OutputConnection

		public var description: String {
			get {
				var result: String
				switch self {
				case .InputConnection:  result = "Input"
				case .OutputConnection:	result = "Output"
				}
				return result
			}
		}
	}

	public enum ValueObject {
		case PrimitiveValue(value: CNValue)
		case ClassValue(name: String, value: Array<CNObjectNotation>)
		case EventMethodValue(type: CNValueType, script: String)
		case ListenerMethodValue(type: CNValueType, pathExpressions: Array<CNPathExpression>, script: String)
		case ConnectionValue(type: ConnectionValueType, pathExpression: CNPathExpression)
	}

	private var mIdentifier	: String
	private var mValue	: ValueObject
	private var mLineNo	: Int

	public var identifier	: String	{ get{ return mIdentifier }	}
	public var value	: ValueObject	{ get{ return mValue	  }	}
	public var lineNo	: Int		{ get{ return mLineNo	  }	}

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
		let arrayval = CNValue(arrayValue: value)
		mIdentifier	= ident
		mValue		= ValueObject.PrimitiveValue(value: arrayval)
		mLineNo		= line
	}

	public init(identifier ident: String, setValue value: Array<CNValue>, lineNo line: Int){
		let setval = CNValue(arrayValue: value)
		mIdentifier	= ident
		mValue		= ValueObject.PrimitiveValue(value: setval)
		mLineNo		= line
	}

	public init(identifier ident: String, className name: String, properties prop: Array<CNObjectNotation>, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.ClassValue(name: name, value: prop)
		mLineNo		= line
	}

	public init(identifier ident: String, type valtype: CNValueType, eventScript scr: String, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.EventMethodValue(type: valtype, script: scr)
		mLineNo		= line
	}

	public init(identifier ident: String, type valtype: CNValueType, pathExpressions path: Array<CNPathExpression>, listenerScript scr: String, lineNo line: Int){
		mIdentifier	= ident
		mValue		= ValueObject.ListenerMethodValue(type: valtype, pathExpressions: path, script: scr)
		mLineNo		= line
	}

	public var primitiveValue: CNValue? {
		switch mValue {
		case .PrimitiveValue(let val):
			return val
		default:
			return nil
		}
	}

	public var classValue: (String, Array<CNObjectNotation>)? {
		switch mValue {
		case .ClassValue(let name, let props):
			return (name, props)
		default:
			return nil
		}
	}

	public var eventMethodValue: (CNValueType, String)? {
		switch mValue {
		case .EventMethodValue(let type, let scr):
			return (type, scr)
		default:
			return nil
		}
	}

	public var listnerMethodValue: (CNValueType, Array<CNPathExpression>, String)? {
		switch mValue {
		case .ListenerMethodValue(let type, let exps, let scr):
			return (type, exps, scr)
		default:
			return nil
		}
	}

	public func typeName() -> String {
		var result: String
		switch mValue {
		case .PrimitiveValue(let v):			result = v.type.description
		case .ClassValue(let name, _):			result = name
		case .EventMethodValue(let type, _):		result = type.description
		case .ListenerMethodValue(let type, _, _):	result = type.description
		case .ConnectionValue(let type, _):		result = "Connection(\(type.description)"
		}
		return result
	}
}
