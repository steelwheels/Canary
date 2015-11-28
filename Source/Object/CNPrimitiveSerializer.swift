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
	
	public class func serializeUInt(inout dict : Dictionary<String, AnyObject>, member : String, value : UInt) {
		dict[member] = NSNumber(unsignedInteger: value)
	}
	
	public class func unserializeUInt(dict : Dictionary<String, AnyObject>, member : String) -> (UInt, NSError?) {
		var resval : UInt = 0
		var error  : NSError? = nil
		if let valobj = dict[member] {
			if let value = valobj as? UInt {
				resval = value
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
	
	public class func serializeURL(inout dict : Dictionary<String, AnyObject>, member : String, value : NSURL){
		dict[member] = value.description
	}
	
	public class func unserializeURL(dict : Dictionary<String, AnyObject>, member : String) -> (NSURL?, NSError?) {
		var error  : NSError? = nil
		if let urlstr = dict[member] as? String {
			if let url = NSURL(string: urlstr) {
				return (url, nil)
			} else {
				error = NSError.serializeError("Can not decode URL from \(urlstr)")
			}
		} else {
			error = NSError.serializeError("No member \(member) in \(dict)")
		}
		return (nil, error)
	}
}

