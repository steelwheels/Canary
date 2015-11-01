/**
 * @file		UTObjectSerializer.h
 * @brief	Unit test for CNObjectSerializer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Canary

public func UTObjectSerializer() -> Bool {
	serializeObject("number", obj: NSNumber(float: 1.23))
	serializeObject("string", obj: "Hello, wordl")
	
	let array : Array<String> = ["a", "b"]
	serializeObject("array", obj: array)
	
	let dict : Dictionary<String, NSNumber> = ["k0":0, "k1":1, "k2":2]
	serializeObject("dictionary", obj: NSDictionary(dictionary: dict))
	
	return true
}

private func serializeObject(message: String, obj : NSObject)
{
	let serializer = CNObjectSerializer()
	let result     = serializer.serializeObject(obj)
	print("\(message) : \(result)")
}