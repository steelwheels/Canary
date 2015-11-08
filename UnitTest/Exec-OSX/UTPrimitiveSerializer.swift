/**
* @file		UTPrimitiveSerializer.h
* @brief	Unit test for CNPrimitiveSerializer class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import Canary

public func UTPrimitiveSerializer() -> Bool {
	var result = true
	result = URLSerializer("https://github.com/steelwheels") && result
	result = URLSerializer("file://../file.txt") && result
	return result
}

private func URLSerializer(urlstr : String) -> Bool {
	var dict : Dictionary<String, AnyObject> = [:]
	let urlp = NSURL(string: urlstr)
	if let url = urlp {
		CNPrimitiveSerializer.serializeURL(&dict, member: "URL", value: url)
		if !dumpDict(dict){
			return false
		}
		
		let (newurlp, newerrorp) = CNPrimitiveSerializer.unserializeURL(dict, member: "URL")
		if let newerror = newerrorp {
			print("[Error] \(newerror.toString())")
			return false
		}
		if let newurl = newurlp {
			print("NEW URL: \(newurl.absoluteString)")
		} else {
			fatalError("Can not happen")
		}
		return true
	} else {
		print("[Error] Can not allocate URL")
		return false
	}
}

private func dumpDict(dict : Dictionary<String, AnyObject>) -> Bool
{
	let (stringp, errorp) = CNJSONFile.serializeToString(dict)
	if let error = errorp {
		print("[Error] \(error.toString())")
		return false
	} else {
		if let string = stringp {
			print("URL: \"\(string)\"")
			return true
		} else {
			print("[Error] Could not serialize")
			return false
		}
	}
}