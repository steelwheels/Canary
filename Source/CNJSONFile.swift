/**
 * @file	CNJSONFile.swift
 * @brief	Extend CNJSONFile class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNJSONFile {
	public class func readFile(URL url : URL) -> (Dictionary<String, AnyObject>?, NSError?) {
		do {
			var result : Dictionary<String, AnyObject>? = nil
			var error : NSError? = nil
			let datap : NSData?  = NSData(contentsOf: url)
			if let data = datap as? Data {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				if let dict = json as? Dictionary<String, AnyObject> {
					result = dict
				} else {
					error = NSError.parseError(message: "The data type is NOT dictionary in URL:\(url.absoluteString)")
				}
			} else {
				error = NSError.parseError(message: "Failed to read data from  URL:\(url.absoluteString)")
			}
			return (result, error)
		}
		catch {
			let error = NSError.parseError(message: "Can not serialize the objet in URL:\(url.absoluteString)")
			return (nil, error)
		}
	}

	public class func writeFile(URL url: URL, dictionary src: Dictionary<String, AnyObject>) -> NSError? {
		do {
			let data = try JSONSerialization.data(withJSONObject: src, options: JSONSerialization.WritingOptions.prettyPrinted)
			try data.write(to: url, options: .atomic)
			return nil
		}

		catch {
			let error = NSError.parseError(message: "Can not write data into \(url.absoluteString)")
			return error
		}
	}

	public class func serialize(dictionary src: Dictionary<String, AnyObject>) -> (String?, NSError?) {
		do {
			let data = try JSONSerialization.data(withJSONObject: src, options: .prettyPrinted)
			let strp  = String(data: data, encoding: String.Encoding.utf8)
			if let str = strp {
				return (str, nil)
			} else {
				let error = NSError.parseError(message: "Can not translate into string")
				return (nil, error)
			}
		}
		catch {
			let error = NSError.parseError(message: "Can not serialize")
			return (nil, error)
		}
	}

	public class func unserialize(string src : String) -> (Dictionary<String, AnyObject>?, NSError?) {
		do {
			var result : Dictionary<String, AnyObject>? = nil
			var error : NSError? = nil
			let datap = src.data(using: String.Encoding.utf8, allowLossyConversion: false)
			if let data = datap {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				if let dict = json as? Dictionary<String, AnyObject> {
					result = dict
				} else {
					error = NSError.parseError(message: "The data type is NOT dictionary in URL:\(src)")
				}
			}
			return (result, error)
		}
		catch {
			let error = NSError.parseError(message: "Can not serialize the objet in URL:\(src)")
			return (nil, error)
		}
	}
}
