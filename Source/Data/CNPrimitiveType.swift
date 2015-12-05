/**
 * @file   CNPrimitiveType.h
 * @brief  Define primitive data types
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public enum CNTriState {
	case Unknown
	case Yes
	case No
	
	func toString() -> String {
		switch self {
		case .Unknown:	return "Unknown"
		case .Yes:	return "Yes"
		case .No:	return "No"
		}
	}
	
	static func fromString(src : String) -> CNTriState {
		switch src.lowercaseString {
		case "yes":	return .Yes
		case "no":	return .No
		default:	return .Unknown
		}
	}
}