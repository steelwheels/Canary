/*
* @file	CNBookmarkPreference.swift
* @brief	Extend CNBookmarkPreference class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation

public class CNBookmark
{
	public var relativeURL	: NSURL?
	public var bookmark	: NSData
	
	public init(relativeURL url: NSURL?, bookmark bm: NSData){
		relativeURL	= url
		bookmark	= bm
	}
	
	public func encode() -> NSDictionary {
		let dict = NSMutableDictionary(capacity: 2)
		if let url = relativeURL {
			dict.setValue(url, forKey: "relative")
		}
		dict.setValue(bookmark, forKey: "bookmark")
		return dict
	}
	
	public class func decode(dict : NSDictionary) -> CNBookmark {
		var relurl : NSURL?
		if let relval = dict.objectForKey("relative") as? NSURL {
			relurl = relval
		} else {
			relurl = nil
		}
		var bookmark : NSData
		if let bmval = dict.objectForKey("bookmark") as? NSData {
			bookmark = bmval
		} else {
			fatalError("Can not happen")
		}
		return CNBookmark(relativeURL: relurl, bookmark: bookmark)
	}
}

public class CNBookmarkPreference
{
	private class func bookmarkPreferekceKey() -> String {
		return "PersistencePreference"
	}
	
	public class var mainURLs : Array<NSURL> {
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
	
	public class func bookmark(mainURL mainurl: NSURL) -> CNBookmark? {
		var result : CNBookmark? = nil
		if let pathstr = mainurl.path {
			if let prefs = preferences() {
				if let dict = prefs[pathstr] as? NSDictionary {
					result = CNBookmark.decode(dict)
				}
			}
		} else {
			NSLog("Invalid URL: \(mainurl.description)")
		}
		return result
	}
	
	public class func addBookmark(mainURL mainurl: NSURL, bookmark: CNBookmark) -> NSError? {
		var result : NSError? = nil
		if let pathstr = mainurl.path {
			let preference = NSUserDefaults.standardUserDefaults()
			if var prefs = preferences() {
				prefs[pathstr] = bookmark.encode()
				preference.setObject(prefs, forKey: bookmarkPreferekceKey())
			} else {
				let newprefs = [pathstr: bookmark.encode()]
				preference.setObject(newprefs, forKey: bookmarkPreferekceKey())
			}
		} else {
			result = NSError.fileError("Invalid URL: \(mainurl.description)")
		}
		return result
	}
	
	public class func clearBookmarks() {
		let preference = NSUserDefaults.standardUserDefaults()
		let emptydict : [String : AnyObject] = [:]
		preference.setObject(emptydict, forKey: bookmarkPreferekceKey())
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

