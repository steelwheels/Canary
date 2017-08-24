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

	public var id:   Int		{ get { return mOptionId } }
	public var name: String		{ get { return mOptionName } }
	public var type: CNValueType	{ get { return mValueType } }

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

	public var type:  CNOptionType { get { return mOptionType! } }
	public var value: CNValue	     { get { return mOptionValue } }

	public init(type otype: CNOptionType, value oval: CNValue){
		mOptionType	= otype
		mOptionValue	= oval
	}

	public func toText() -> CNTextSection {
		let optid  = mOptionType!.id
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
	private var	mErrors:		Array<String>

	public init(){
		mOptionTypes	= []
		mOptionValues	= []
		mArguments	= []
		mErrors		= []
	}

	public var optionTypes:  Array<CNOptionType>  { get { return mOptionTypes }}
	public var optionValues: Array<CNOptionValue> { get { return mOptionValues }}
	public var errors:	 Array<String>        { get { return mErrors }}

	public func parseArguments(types otypes: Array<CNOptionType>, arguments args: Array<String>){
		mOptionTypes	= otypes

		let argnum = args.count
		var i : Int = 0
		while i < argnum {
			let arg = args[i]
			if let type = isOptionString(string: arg) {
				if type.hasOptionValue() {
					/* Option with parameter */
					let nexti = i + 1
					if nexti < argnum {
						let nextarg = args[nexti]
						if let value = decodeOptionValue(type: type, argument: nextarg) {
							let option = CNOptionValue(type: type, value: value)
							mOptionValues.append(option)
						} else {
							let error = "The parameter \(nextarg) is not suitable for the option \"\(type.name)\""
							mErrors.append(error)
						}
					} else {
						let error = "The option \"\(type.name)\" require parameter"
						mErrors.append(error)
					}
					i = nexti
				} else {
					/* Option without parameter */
					let nullvalue = CNValue(booleanValue: false)
					let option    = CNOptionValue(type: type, value: nullvalue)
					mOptionValues.append(option)
				}
			} else {
				mArguments.append(arg)
			}
			i += 1
		}
	}

	private func isOptionString(string str: String) -> CNOptionType? {
		for type in mOptionTypes {
			let optname = "--" + type.name
			if optname == str {
				return type
			}
		}
		return nil
	}

	private func decodeOptionValue(type otype: CNOptionType, argument arg: String) -> CNValue? {
		switch otype.type {
		case .VoidType:
			break
		case .BooleanType:
			let larg = arg.lowercased()
			if larg == "true" {
				return CNValue(booleanValue: true)
			} else if larg == "false" {
				return CNValue(booleanValue: false)
			}
		case .CharacterType:
			if arg.characters.count == 1 {
				let c = arg.characters[arg.startIndex]
				return CNValue(characterValue: c)
			}
		case .IntType:
			let len = arg.characters.count
			if len >= 3 {
				if arg.characters[arg.startIndex] == "0" {
					let nextidx = arg.index(after: arg.startIndex)
					switch arg.characters[nextidx] {
					case "x", "X":	return decodeOptionIntegerValue(argument: arg, radix: 16)
					case "o", "O":	return decodeOptionIntegerValue(argument: arg, radix:  8)
					case "b", "B":  return decodeOptionIntegerValue(argument: arg, radix:  2)
					default:
						break
					}
				}
			}
			return decodeOptionIntegerValue(argument: arg, radix: 10)
		case .FloatType:
			if let val = Float(arg) {
				return CNValue(floatValue: val)
			}
		case .DoubleType:
			if let val = Double(arg) {
				return CNValue(doubleValue: val)
			}
		case .StringType:
			return CNValue(stringValue: arg)
		default:
			break
		}
		return nil
	}

	public func decodeOptionIntegerValue(argument arg:String, radix rdx: Int) -> CNValue? {
		if let val = Int(arg, radix: rdx) {
			return CNValue(intValue: val)
		} else {
			return nil
		}
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


