/**
 * @file	NSNumberExtension.h
 * @brief	Define CNList class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public enum NSNumberKind:Int {
	case int8Number
	case uInt8Number
	case int16Number
	case uInt16Number
	case int32Number
	case uInt32Number
	case int64Number
	case uInt64Number
	case doubleNumber
	case floatNumber

	public var description:String {
		get {
			var result: String
			switch self {
			case .int8Number:	result = "int8"
			case .uInt8Number:	result = "uInt8"
			case .int16Number:	result = "int16"
			case .uInt16Number:	result = "uInt16"
			case .int32Number:	result = "int32"
			case .uInt32Number:	result = "uInt32"
			case .int64Number:	result = "int64"
			case .uInt64Number:	result = "uInt64"
			case .doubleNumber:	result = "double"
			case .floatNumber:	result = "float"
			}
			return result
		}
	}
}

extension NSNumber
{
	public var kind: NSNumberKind {
		get { return decodeKind() }
	}

	internal func decodeKind() -> NSNumberKind {
		var result: NSNumberKind
		switch String(cString: self.objCType) {
		case "c": result = .int8Number
		case "C": result = .uInt8Number
		case "s": result = .int16Number
		case "S": result = .uInt16Number
		case "i": result = .int32Number
		case "I": result = .uInt32Number
		case "q": result = .int64Number
		case "Q": result = .uInt64Number
		case "f": result = .floatNumber
		case "d": result = .doubleNumber
		default:  fatalError("Unknown number kind")
		}
		return result
	}
}
