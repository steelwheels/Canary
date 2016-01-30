/*
 * @file	CNBookmarkPreference.swift
 * @brief	Extend CNBookmarkPreference class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNBookmarkPreference
{
	public static let sharedPreference = CNBookmarkPreference()
	
	private var mBookmarks : CNBookmarks
	
	private init(){
		if let pref = CNBookmarkPreference.rootPreferences() {
			mBookmarks = CNBookmarks.decode(pref)
		} else {
			mBookmarks = CNBookmarks()
		}
	}
	
	public func saveToUserDefaults(mainURL mainurl: NSURL, relativeURL relurl: NSURL?)
	{
		mBookmarks.addBookmark(mainURL: mainurl, relativeURL: relurl)
	}

	public func loadFromUserDefaults(mainpath:String, relativeURL: NSURL?) -> CNFileURL? {
		return mBookmarks.loadFromUserDefaults(mainpath, relativeURL: relativeURL)
	}
	
	public func clear() {
		mBookmarks.clear()
	}
	
	public func synchronize() {
		let dict = mBookmarks.encode()
		let preference = NSUserDefaults.standardUserDefaults()
		preference.setObject(dict, forKey: CNBookmarkPreference.bookmarkPreferekceKey())
		preference.synchronize()
	}
	
	public func dump() {
		mBookmarks.dump()
	}
	
	private class func rootPreferences() -> NSDictionary? {
		let preference = NSUserDefaults.standardUserDefaults()
		if let dict = preference.dictionaryForKey(CNBookmarkPreference.bookmarkPreferekceKey()) {
			return dict
		} else {
			return nil
		}
	}
	
	private class func bookmarkPreferekceKey() -> String {
		return "bookmarks"
	}
}
