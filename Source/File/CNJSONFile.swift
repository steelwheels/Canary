/**
 * @file	CNJSONFile.swift
 * @brief	Extend CNJSONFile class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNJSONFile {
	public class func readFile(url : NSURL) -> (Dictionary<String, AnyObject>?, NSError?) {
		do {
			var result : Dictionary<String, AnyObject>? = nil
			var error : NSError? = nil
			let datap : NSData?  = NSData(contentsOfURL: url)
			if let data = datap {
				let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
				if let dict = json as? Dictionary<String, AnyObject> {
					result = dict
				} else {
					error = NSError.parseError("The data type is NOT dictionary in URL:\(url.absoluteString)")
				}
			} else {
				error = NSError.parseError("Failed to read data from  URL:\(url.absoluteString)")
			}
			return (result, error)
		}
		catch {
			let error = NSError.parseError("Can not serialize the objet in URL:\(url.absoluteString)")
			return (nil, error)
		}
	}

	public class func writeFile(url: NSURL, src: Dictionary<String, AnyObject>) -> NSError? {
		do {
			let data = try NSJSONSerialization.dataWithJSONObject(src, options: NSJSONWritingOptions.PrettyPrinted)
			data.writeToURL(url, atomically: true)
			return nil
		}
		catch {
			let error = NSError.parseError("Can not write data into \(url.absoluteString)")
			return error
		}
	}

	public class func serializeToString(src: Dictionary<String, AnyObject>) -> (String?, NSError?) {
		do {
			let data = try NSJSONSerialization.dataWithJSONObject(src, options: NSJSONWritingOptions.PrettyPrinted)
			let strp  = String(data: data, encoding: NSUTF8StringEncoding)
			if let str = strp {
				return (str, nil)
			} else {
				let error = NSError.parseError("Can not translate into string")
				return (nil, error)
			}
		}
		catch {
			let error = NSError.parseError("Can not serialize")
			return (nil, error)
		}
	}
}
