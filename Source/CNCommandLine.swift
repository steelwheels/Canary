/*
 * @file	CNCommandLine.swift
 * @brief	Define CNCommandLine class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNOptionType
{
	private var mOptionId:		Int		// User defined option ID
	private var mOptionName:	String
	private var mValueType:		CNValueType

	public var optionId: Int		{ get { return mOptionId } }
	public var optionName: String		{ get { return mOptionName } }
	public var valueType: CNValueType	{ get { return mValueType } }

	public init(id oid: Int, name oname: String, type vtype: CNValueType){
		mOptionId	= oid
		mOptionName	= oname
		mValueType	= vtype
	}

	public func hasOptionValue() -> Bool {
		return mValueType != .VoidType
	}

	public func toText() -> CNTextSection {
		let sect = CNTextSection()
		sect.add(string: "id: \(mOptionId), name:\(mOptionName), type:\(mValueType.description)")
		return sect
	}
}

public struct CNOptionValue
{
	private weak var mOptionType:		CNOptionType?
	private var	 mOptionValue:		CNValue

	public var optionType:  CNOptionType { get { return mOptionType! } }
	public var optionValue: CNValue	     { get { return mOptionValue } }

	public init(type otype: CNOptionType, value oval: CNValue){
		mOptionType	= otype
		mOptionValue	= oval
	}

	public func toText() -> CNTextSection {
		let optid  = mOptionType!.optionId
		let valstr = mOptionValue.description
		let sect  = CNTextSection()
		sect.add(string: "option-id: \(optid), value:\(valstr)")
		return sect
	}
}

public class CNCommandLine
{
	private var	mOptionTypes:		Array<CNOptionType>
	private var	mOptionValues:		Array<CNOptionValue>
	private var	mArguments:		Array<String>

	public var optionTypes:   Array<CNOptionType>  { get { return mOptionTypes }}
	public var optionValuess: Array<CNOptionValue> { get { return mOptionValues }}

	public init(types otypes: Array<CNOptionType>){
		mOptionTypes	= otypes
		mOptionValues	= []
		mArguments	= []
	}

	public func addOption(value val: CNOptionValue){
		mOptionValues.append(val)
	}

	public func addArgument(value val: String){
		mArguments.append(val)
	}

	public func toText() -> CNTextSection {
		let opttypesect = CNTextSection()
		opttypesect.header = "[OptionTypes]"
		for opttype in mOptionTypes {
			opttypesect.add(text: opttype.toText())
		}

		let optvalsect = CNTextSection()
		optvalsect.header = "[OptionValues]"
		for optval in mOptionValues {
			optvalsect.add(text: optval.toText())
		}

		let argsect = CNTextSection()
		argsect.header = "[Arguments]"
		argsect.add(strings: mArguments)
		let sumsect = CNTextSection()

		sumsect.header = "[CommandLine]"
		sumsect.add(text: opttypesect)
		sumsect.add(text: optvalsect)
		sumsect.add(text: argsect)
		return sumsect
	}
}
