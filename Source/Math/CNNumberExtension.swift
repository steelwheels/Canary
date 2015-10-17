/**
 * @file	CNNumberExtension.h
 * @brief	Extend NSNumber class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

internal func numberKindString(number : NSNumber) -> String {
	if let str = String.fromCString(number.objCType) {
		return str
	} else {
		fatalError("Unknown number type")
	}
}

internal class CNNumberCode {
	private static var singletonObject = CNNumberCode()
	
	internal let int8String		= numberKindString(NSNumber(char: 1))
	internal let int16String	= numberKindString(NSNumber(short: 123))
	internal let int32String	= numberKindString(NSNumber(int: 123))
	internal let int64String	= numberKindString(NSNumber(integer: 123))
	internal let uInt16String	= numberKindString(NSNumber(unsignedShort: 123))
	internal let uInt32String	= numberKindString(NSNumber(unsignedInt: 123))
	internal let uInt64String	= numberKindString(NSNumber(unsignedInteger: 123))
	internal let floatString	= numberKindString(NSNumber(float: 12.3))
	internal let doubleString	= numberKindString(NSNumber(double: 12.3))
	
	private init(){
	}
	
	internal class func sharedNumberCode() -> CNNumberCode {
		return singletonObject
	}

	internal func dumpObjCCode(){
		print("int8   (char:)              ... \(int8String)")
		print("int16  (short:)             ... \(int16String)")
		print("int32  (int:)               ... \(int32String)")
		print("int64  (intger:)            ... \(int64String)")
		print("uint16 (unsigned short:)    ... \(uInt16String)")
		print("uint32 (unsigned int:)      ... \(uInt32String)")
		print("uint64 (unsigned intger:)   ... \(uInt64String)")
		print("float  (Float:)             ... \(floatString)")
		print("double (Double:)            ... \(floatString)")
	}
}

extension NSNumber {
	public enum NumberKind {
		case UnknownNumber
		case Int8Number
		case Int16Number
		case Int32Number
		case Int64Number
		case UInt16Number
		case UInt32Number
		case UInt64Number
		case FloatNumber
		case DoubleNumber
		
		public func toString() -> String {
			var result = "?"
			switch self {
			case .UnknownNumber:
				result = "Unknown"
			case .Int8Number:
				result = "Int8"
			case .Int16Number:
				result = "int16"
			case .Int32Number:
				result = "int32"
			case .Int64Number:
				result = "Int64"
			case .UInt16Number:
				result = "UInt16"
			case .UInt32Number:
				result = "UInt32"
			case .UInt64Number:
				result = "UInt64"
			case .FloatNumber:
				result = "Float"
			case .DoubleNumber:
				result = "Double"
			}
			return result
		}
	}
	
	public func kind() -> NumberKind {
		let code   = CNNumberCode.sharedNumberCode()
		let kindstr = numberKindString(self)
		var kind : NumberKind
		if(kindstr == code.int8String){
			kind = .Int8Number
		} else if(kindstr == code.int16String){
			kind = .Int16Number
		} else if(kindstr == code.int32String){
			kind = .Int32Number
		} else if(kindstr == code.int64String){
			kind = .Int64Number
		} else if(kindstr == code.uInt16String){
			kind = .UInt16Number
		} else if(kindstr == code.uInt32String){
			kind = .UInt32Number
		} else if(kindstr == code.uInt64String){
			kind = .UInt64Number
		} else if(kindstr == code.floatString){
			kind = .FloatNumber
		} else if(kindstr == code.doubleString){
			kind = .DoubleNumber
		} else {
			kind = .UnknownNumber
		}
		return kind
	}
	
	public func toString() -> String {
		var result = ""
		switch kind(){
		case .UnknownNumber:
			result = "\(self)"
		case .Int8Number:
			let val : Int8 = self.charValue
			result = "\(val)"
		case .Int16Number:
			let val : Int16 = self.shortValue
			result = "\(val)"
		case .Int32Number:
			let val : Int32 = self.intValue
			result = "\(val)"
		case .Int64Number:
			let val : Int64 = Int64(self.longValue)
			result = "\(val)"
		case .UInt16Number:
			let val : UInt16 = self.unsignedShortValue
			result = "\(val)"
		case .UInt32Number:
			let val : UInt32 = self.unsignedIntValue
			result = "\(val)"
		case .UInt64Number:
			let val : UInt64 = self.unsignedLongLongValue
			result = "\(val)"
		case .FloatNumber:
			let val : Float = self.floatValue
			result = "\(val)"
		case .DoubleNumber:
			let val : Double = self.doubleValue
			result = "\(val)"
		}
		return result
	}
	
	public class func dumpObjCTypes(){
		let code   = CNNumberCode.sharedNumberCode()
		code.dumpObjCCode()
	}
}
