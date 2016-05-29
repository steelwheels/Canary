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
	public class func URLForHomeDirectory() -> NSURL {
		let homedir = NSHomeDirectory()
		return NSURL(fileURLWithPath: homedir, isDirectory: true)
	}
	
	public class func URLForBundleFile(bundlename : String?, filename : String?, ofType: String?) -> (NSURL?, NSError?) {
		let mainbundle = NSBundle.mainBundle()
		if let bundlepath = mainbundle.pathForResource(bundlename, ofType: "bundle") {
			if let resourcebundle = NSBundle(path: bundlepath) {
				if let resourcepath = resourcebundle.pathForResource(filename, ofType: ofType){
					let url = NSURL(string: "file://" + resourcepath)
					return (url, nil)
				} else {
					let error = NSError.fileError("File \"\(filename)\" of type \"\(ofType)\" is not found")
					return (nil, error)
				}
			} else {
				let error = NSError.fileError("Failed to allocate bundle \"\(bundlepath)\"")
				return (nil, error)
			}
		} else {
			let error = NSError.fileError("\(bundlename).bundle is not found")
			return (nil, error)
		}
	}
}
