/*
 * @file	CNCommandLineParser.swift
 * @brief	Define CNCommandLineParser class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNCommandLineParser
{
	private var mCommandLine:	CNCommandLine
	private var mErrors:		Array<String>

	public var commandLine: CNCommandLine { get { return mCommandLine }}
	public var errors: Array<String>      { get { return mErrors }}

	public init(types otypes: Array<CNOptionType>){
		mCommandLine = CNCommandLine(types: otypes)
		mErrors      = []
	}

	public func parse(inputStrings instrs: Array<String>) -> Bool {
		var result = true
		let innum = instrs.count
		var i : Int = 0
		while i < innum {
			let instr = instrs[i]
			if let type = isOptionString(string: instr) {
				if type.hasOptionValue() {
					/* Option with parameter */
					let nexti = i + 1
					if nexti < innum {
						let nextstr = instrs[nexti]
						if let value = decodeOptionValue(type: type, string: nextstr) {
							let option = CNOptionValue(type: type, value: value)
							mCommandLine.addOption(value: option)
						} else {
							let error = "The parameter \(nextstr) is not suitable for the option \"\(type.optionName)\""
							mErrors.append(error)
							result = false
						}
					} else {
						let error = "The option \"\(type.optionName)\" require parameter"
						mErrors.append(error)
						result = false
					}
					i = nexti
				} else {
					/* Option without parameter */
					let nullvalue = CNValue(booleanValue: false)
					let option    = CNOptionValue(type: type, value: nullvalue)
					mCommandLine.addOption(value: option)
				}
			} else {
				mCommandLine.addArgument(value: instr)
			}
			i += 1
		}
		return result
	}

	private func isOptionString(string str: String) -> CNOptionType? {
		for type in mCommandLine.optionTypes {
			let optname = "--" + type.optionName
			if optname == str {
				return type
			}
		}
		return nil
	}

	private func decodeOptionValue(type otype: CNOptionType, string str: String) -> CNValue? {
		let (err, tokens) = CNStringToToken(string: str)
		switch err {
		case .NoError:
			if tokens.count == 1 {
				let rawval = CNTokenToValue(token: tokens[0])
				if let castval = rawval.cast(to: otype.valueType) {
					return castval
				}
			}
		case .ParseError(_, _), .TokenizeError(_, _):
			break
		}
		return nil
	}
}
