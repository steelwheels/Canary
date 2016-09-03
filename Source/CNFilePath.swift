/**
 * @file	CNFilePath.swift
 * @brief	Define CNFilePath class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

/**
 * Define methods to operate the file URL
 */
public class CNFilePath
{
	public class func URLForHomeDirectory() -> URL {
		let homedir = NSHomeDirectory()
		return URL(fileURLWithPath: homedir, isDirectory: true)
	}
	
	public class func URLForBundleFile(bundleName bname: String?, fileName fname: String?, ofType type: String?) -> (URL?, NSError?) {
		let mainbundle = Bundle.main
		if let bundlepath = mainbundle.path(forResource: bname, ofType: "bundle") {
			if let resourcebundle = Bundle(path: bundlepath) {
				if let resourcepath = resourcebundle.path(forResource: fname, ofType: type){
					let url = URL(string: "file://" + resourcepath)
					return (url, nil)
				} else {
					let error = NSError.fileError(message: "File \"\(fname)\" of type \"\(type)\" is not found")
					return (nil, error)
				}
			} else {
				let error = NSError.fileError(message: "Failed to allocate bundle \"\(bundlepath)\"")
				return (nil, error)
			}
		} else {
			let error = NSError.fileError(message: "\(bname).bundle is not found")
			return (nil, error)
		}
	}
}

