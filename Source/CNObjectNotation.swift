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
		case PrimitiveValue(value: CNValue)
		case ObjectValue(value: Array<CNObjectNotation>)
	}

	private var mLabel	: String?
	private var mClassName	: String
	private var mValue	: ValueType

	public init(label lab: String?, primitiveValue value: CNValue) {
		mLabel		= lab
		mClassName	= value.typeDescription
		mValue		= ValueType.PrimitiveValue(value: value)
	}

	public init(label lab: String?, className cname: String, objectValues vals: Array<CNObjectNotation>){
		mLabel		= lab
		mClassName	= cname
		mValue		= ValueType.ObjectValue(value: vals)
	}

	public var label:	String?   { return mLabel }
	public var className:	String    { return mClassName }
	public var value:	ValueType { return mValue }
}
