/**
 * @file	CNErrorExtension.swift
 * @brief	Extend NSError class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public enum CNErrorCode {
	case ParseError
	case FileError
	case SerializeError
}

public extension NSError
{
	public class func domain() -> String {
		return "github.com.steelwheels.Canary"
	}
	
	public class func codeToValue(code : CNErrorCode) -> Int {
		var value : Int = 0
		switch(code){
		case .ParseError:
			value = 1
		case .FileError:
			value = 2
		case .SerializeError:
			value = 3
		}
		return value
	}
	
	public class func errorLocationKey() -> String {
		return "errorLocation"
	}
	
	public class func parseError(message : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message]
		let error = NSError(domain: self.domain(), code: codeToValue(CNErrorCode.ParseError), userInfo: userinfo)
		return error
	}
	
	public class func parseError(message : NSString, location : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message, self.errorLocationKey(): location]
		let error = NSError(domain: self.domain(), code: codeToValue(CNErrorCode.ParseError), userInfo: userinfo)
		return error
	}
	
	public class func fileError(message : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message]
		let error = NSError(domain: self.domain(), code: codeToValue(CNErrorCode.FileError), userInfo: userinfo)
		return error
	}
	
	public class func fileError(message : NSString, location : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message, self.errorLocationKey(): location]
		let error = NSError(domain: self.domain(), code: codeToValue(CNErrorCode.FileError), userInfo: userinfo)
		return error
	}
	
	public class func serializeError(message : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message]
		let error = NSError(domain: self.domain(), code: codeToValue(CNErrorCode.SerializeError), userInfo: userinfo)
		return error
	}
	
	public class func serializeError(message : NSString, location : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message, self.errorLocationKey(): location]
		let error = NSError(domain: self.domain(), code: codeToValue(CNErrorCode.SerializeError), userInfo: userinfo)
		return error
	}
	
	public func toString() -> String {
		if let dict : Dictionary = userInfo {
			var message : String
			if let desc = dict[NSLocalizedDescriptionKey] as? String {
				message = desc
			} else {
				message = "Unknown error "
			}
			let lockey : String = NSError.errorLocationKey()
			if let location = dict[lockey] as? String {
				message = message + "in " + location
			}
			return message
		} else {
			return "Unknown error"
		}
	}
}


