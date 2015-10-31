/**
* @file		CNObjectSerializer.h
* @brief	Define CNObjectSerializer class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation

public class CNObjectSerializer : CNObjectVisitor
{
	var currentString : String = ""
	
	public func serializeObject(object : NSObject) -> String {
		acceptObject(object)
		return currentString
	}
	
	public override func visitNumberObject(number : NSNumber){
		currentString += number.description
	}
	
	public override func visitStringObject(string : NSString){
		currentString += String(string)
	}
	
	public override func visitDateObject(date : NSDate){
		currentString += date.description
	}
	
	public override func visitDictionaryObject(dict : NSDictionary)	{
		if let dictobj = dict as? Dictionary<String, AnyObject> {
			do {
				let dictdata  = try NSJSONSerialization.dataWithJSONObject(dictobj, options: NSJSONWritingOptions.PrettyPrinted)
				let strdata   = NSString(data: dictdata, encoding: NSUTF8StringEncoding)
				if let string = strdata {
					currentString = String(string)
				} else {
					fatalError("Nil string is NOT allowed")
				}
			}
			catch {
				fatalError("Can not generate JSON from dictionary")
			}
		} else {
			fatalError("Unacceptable array element")
		}
	}
	
	public override func visitArrayObject(arr : NSArray) {
		var arraystr = "["
		var is1stelm = true
		for elm in arr {
			if is1stelm {
				is1stelm = false
			} else {
				arraystr += ", "
			}
			if let elmobj = elm as? NSObject {
				currentString = ""
				acceptObject(elmobj)
				arraystr += currentString
			} else {
				fatalError("Unacceptable array element")
			}
		}
		arraystr += "]"
		currentString = arraystr
	}
	
	public override func visitUnknownObject(obj : NSObject)	{
		currentString = "<unknown>"
	}
}
