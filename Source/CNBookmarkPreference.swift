/*
* @file	CNBookmarkPreference.swift
* @brief	Extend CNBookmarkPreference class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation

public class CNBookmarkPreference
{
	private class func bookmarkPreferekceKey() -> String {
		return "PersistencePreference"
	}
	
	public class var URLs : Array<NSURL> {
		get {
			var urls : Array<NSURL> = []
			if let dict = preferences() {
				for key in dict.keys {
					let newurl = NSURL(fileURLWithPath: key)
					urls.append(newurl)
				}
			}
			return urls
		}
	}
	
	public class func bookmark(url: NSURL) -> NSData? {
		var result : NSData? = nil
		if let pathstr = url.path {
			if let prefs = preferences() {
				if let bookmark = prefs[pathstr] as? NSData {
					result = bookmark
				}
			}
		} else {
			NSLog("Invalid URL: \(url.description)")
		}
		return result
	}
	
	public class func addBookmark(url: NSURL, bookmark: NSData) -> NSError? {
		var result : NSError? = nil
		if let pathstr = url.path {
			let preference = NSUserDefaults.standardUserDefaults()
			if var prefs = preferences() {
				prefs[pathstr] = bookmark
				preference.setObject(prefs, forKey: bookmarkPreferekceKey())
			} else {
				let newprefs = [pathstr: bookmark]
				preference.setObject(newprefs, forKey: bookmarkPreferekceKey())
			}
		} else {
			result = NSError.fileError("Invalid URL: \(url.description)")
		}
		return result
	}
	
	private class func preferences() -> [String : AnyObject]? {
		let preference = NSUserDefaults.standardUserDefaults()
		if let dict = preference.dictionaryForKey(bookmarkPreferekceKey()) {
			return dict
		} else {
			return nil
		}
	}
}

