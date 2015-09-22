/**
 * @file	CNURL.swift
 * @brief	Extend NSURL class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
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
	public class func allocateURLForFile(filename : String) -> (NSURL?, NSError?) {
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
					let url = NSURL(string: "file:/" + fullpath)
					return (url, nil)
				} else {
					let url = NSURL(string: "file:/" + pathstr)
					return (url, nil)
				}
			}
		}
		
		let error = NSError.fileError("Invalid URL: \(filename)")
		return (nil, error)
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





