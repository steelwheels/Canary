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
	print("* test URL")
	result = testURL("a") && result
	result = testURL("/tmp/a") && result
	result = testURL("http://www.yahoo.co.jp") && result
	print("* test Bundle")
	result = testBundle("unittest", filetype: "txt")
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

private func testBundle(filename : String, filetype : String) -> Bool
{
	var result = true
	let (urlobj, errorobj) = NSURL.allocateURLForBundleFile("UnitTest", filename: filename, ofType: filetype)
	if let url = urlobj {
		let urlstr = url.absoluteString
		print("URL: \(urlstr)")
	} else {
		print("[Error] Failed to get URL")
		if let error = errorobj {
			let errmsg = error.toString()
			print("\(errmsg)")
		} else {
			print("Unknown error")
		}
		result = false
	}
	return result
}
