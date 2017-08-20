/*
 * @file	CNValueUtil.swift
 * @brief	Define utility functions for CNValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public func CNTokenToValue(token tkn: CNToken) -> CNValue
{
	let result: CNValue
	switch tkn.type {
	case .SymbolToken(let charval):
		result = CNValue(characterValue: charval)
	case .BoolToken(let boolval):
		result = CNValue(booleanValue: boolval)
	case .IdentifierToken(let identval):
		result = CNValue(stringValue: identval)
	case .UIntToken(let uintval):
		result = CNValue(uIntValue: uintval)
	case .IntToken(let intval):
		result = CNValue(intValue: intval)
	case .DoubleToken(let dblval):
		result = CNValue(doubleValue: dblval)
	case .StringToken(let strval):
		result = CNValue(stringValue: strval)
	case .TextToken(let txtval):
		result = CNValue(stringValue: txtval)
	}
	return result
}
