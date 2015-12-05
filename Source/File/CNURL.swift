/**
 * @file	CNURL.swift
 * @brief	Extend NSURL class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public enum CNURIScheme {
	case NoScheme		/**<< No scheme		*/
	case FileScheme		/**<< File scheme	*/
	case HttpScheme		/**<< HTTP scheme	*/
	case HttpsScheme	/**<< HTTPS scheme	*/
	
	func toString() -> String {
		var result = ""
		switch self {
		case .NoScheme:	result = ""
		case .FileScheme:	result = "file:"
		case .HttpScheme:	result = "http:"
		case .HttpsScheme:	result = "https:"
		}
		return result
	}
}

extension NSURL {
	public class func URLForResourceOfMainBundle() -> NSURL {
		let bundlepath = NSBundle.mainBundle().bundlePath
		let fullpath   = "file://" + bundlepath + "/Contents/Resources"
		if let url = NSURL(string: fullpath) {
			return url
		} else {
			fatalError("Invalid URL: $(fullpath)")
		}
	}
	
	public class func URLForFile(filename : String) -> (NSURL?, NSError?) {
		if filename.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
			let error = NSError.parseError("No input file name")
			return (nil, error)
		}
		/* If the scheme prefix is already given, allocate URL for it */
		if NSURL.schemeOfFileName(filename) != CNURIScheme.NoScheme {
			if let url = NSURL(string: filename) {
				return (url, nil)
			} else {
				let error = NSError.fileError("Invalid URL: \(filename)")
				return (nil, error)
			}
		}

		/* Standardizing path string */
		if let path = NSURL.normalizedPath(filename) {
			if let pathstr = path.path {
				if !pathstr.hasPrefix("/") {
					let filemgr  = NSFileManager.defaultManager()
					let curdir   = filemgr.currentDirectoryPath
					let fullpath = curdir + "/" + filename
					let url = NSURL(string: "file://" + fullpath)
					return (url, nil)
				} else {
					let url = NSURL(string: "file://" + pathstr)
					return (url, nil)
				}
			}
		}
		
		let error = NSError.fileError("Invalid URL: \(filename)")
		return (nil, error)
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
	
	public class func URLForMainBundleFile(filename : String?, ofType: String?) -> (NSURL?, NSError?) {
		let mainbundle = NSBundle.mainBundle()
		if let mainpath = mainbundle.pathForResource(filename, ofType: ofType){
			let url = NSURL(string: "file://" + mainpath)
			return (url, nil)
		} else {
			let error = NSError.fileError("File \"\(filename)\" of type \"\(ofType)\" is not found")
			return (nil, error)
		}
	}
	
	private class func schemeOfFileName(filename : String) -> CNURIScheme {
		let schemes : Array<CNURIScheme> = [CNURIScheme.FileScheme, CNURIScheme.HttpScheme, CNURIScheme.HttpScheme]
		for scheme in schemes {
			if filename.hasPrefix(scheme.toString()) {
				return scheme
			}
		}
		return CNURIScheme.NoScheme
	}
	
	private class func normalizedPath(filename : String) -> NSURL? {
		if let path0 = NSURL(string: filename) {
			if let path1 = path0.URLByStandardizingPath {
				return path1
			}
		}
		return nil
	}
}





