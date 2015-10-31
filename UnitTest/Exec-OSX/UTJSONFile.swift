/**
 * @file	UTJSONFole.h
 * @brief	Unit test for CNJSONFile class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Canary

public func UTJSONFile() -> Bool {
	var dict : Dictionary<String, AnyObject> = ["a": NSNumber(bool: true)]
	let elm0 : Array<NSNumber> = [NSNumber(integer: 1), NSNumber(integer: 2), NSNumber(integer: 3)] ;
	dict["b"] = elm0 ;

	let url = NSURL(fileURLWithPath: "UTJSONFile.json")
	if let error = CNJSONFile.writeFile(url, src: dict) {
		print("[Error] \(error.toString())")
		return false
	} else {
		
		let (rdata, errorp) = CNJSONFile.readFile(url)
		if let error = errorp {
			print("[Error] \(error.toString())")
			return false
		} else {
			print("* Read file: \(rdata!)")
			return true
		}
	}
}
