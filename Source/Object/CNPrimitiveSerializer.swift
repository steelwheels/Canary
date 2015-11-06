/**
 * @file	CNPrimitiveSerializer.h
 * @brief	Define CNPrimitiveSerializer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNPrimitiveSerializer
{
	public class func serializeString(inout dict : Dictionary<String, AnyObject>, member : String, value : String) {
		dict[member] = NSString(UTF8String: value)
	}
	
	public class func unserializeString(dict : Dictionary<String, AnyObject>, member : String) -> (String, NSError?) {
		var resval : String   = ""
		var error  : NSError? = nil
		if let valobj = dict[member] {
			if let value = valobj as? NSString {
				resval = String(value)
			} else {
				error = NSError.serializeError("Invalid value type \(member) in \(dict)")
			}
		} else {
			error = NSError.serializeError("No member \(member) in \(dict)")
		}
		return (resval, error)
	}
	
	public class func serializeCGFloat(inout dict : Dictionary<String, AnyObject>, member : String, value : CGFloat) {
		dict[member] = NSNumber(double: Double(value))
	}
	
	public class func unserializeCGFloat(dict : Dictionary<String, AnyObject>, member : String) -> (CGFloat, NSError?) {
		var resval : CGFloat = 0.0
		var error  : NSError? = nil
		if let valobj = dict[member] {
			if let value = valobj as? Double {
				resval = CGFloat(value)
			} else {
				error = NSError.serializeError("Invalid value type \(member) in \(dict)")
			}
		} else {
			error = NSError.serializeError("No member \(member) in \(dict)")
		}
		return (resval, error)
	}
}

