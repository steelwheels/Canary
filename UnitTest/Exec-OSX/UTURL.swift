/**
* @file		UTURL.h
* @brief	Unit test for extension of NSURL
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import Canary

public func UTURL() -> Bool {
	var result = true
	result = testURL("a") && result
	result = testURL("/tmp/a") && result
	result = testURL("http://www.yahoo.co.jp") && result
	return result
}

private func testURL(filename : String) -> Bool
{
	let (url, error) = NSURL.allocateURLForFile(filename)
	if let fileurl = url {
		let pathstr = fileurl.absoluteString
		print("filename:\"\(filename)\" -> URL:\(pathstr)")
		return true
	} else {
		if let err = error {
			let errmsg = err.toString()
			print("ERROR: \(errmsg)")
		} else {
			print("ERROR: Internal error")
		}
		return false
	}
}